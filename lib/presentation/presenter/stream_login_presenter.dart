import 'dart:async';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  StreamLoginPresenter({required this.authentication, required this.validation});

  StreamController<LoginState>? _controller = StreamController<LoginState>.broadcast();
  final LoginState _state = LoginState();

  @override
  Stream<UIError?> get emailErrorStream => _controller?.stream.map((state) => state.emailError).distinct() ?? Stream.value(null);

  @override
  Stream<UIError?> get passwordErrorStream => _controller?.stream.map((state) => state.passwordError).distinct() ?? Stream.value(null);

  @override
  Stream<UIError?> get mainErrorStream => _controller?.stream.map((state) => state.mainError).distinct() ?? Stream.value(null);

  @override
  Stream<bool> get formValidStream => _controller?.stream.map((state) => state.formValid).distinct() ?? Stream.value(false);

  @override
  Stream<bool> get loadingStream => _controller?.stream.map((state) => state.loading).distinct() ?? Stream.value(false);

  @override
  Stream<String?> get navigateToStream => _controller?.stream.map((state) => state.navigateToStream).distinct() ?? Stream.value(null);

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateField(field: "email", value: email);
    _update();
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateField(field: "password", value: password);
    _update();
  }

  @override
  Future<void> auth() async {
    try {
      _state.loading = true;
      _update();

      await authentication.auth(AuthenticationParams(email: _state.email!, password: _state.password!));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UIError.invalidCredentials;
          break;
        default:
          _state.mainError = UIError.unexpected;
      }
    } finally {
      _state.loading = false;
      _update();
    }
  }

  UIError? _validateField({required String field, required String value}) {
    final Map formData = {
      'email': _state.email,
      'password': _state.password,
    };

    final error = validation.validate(field, formData);

    switch (error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  @override
  void dispose() {
    _controller?.close();
    _controller = null;
  }

  void _update() => _controller?.add(_state);

  @override
  void goToSignUp() => _state.navigateToStream = "/login";
}

class LoginState {
  String? email;
  UIError? emailError;
  String? password;
  UIError? passwordError;
  UIError? mainError;
  bool loading = false;
  String? navigateToStream;

  bool get formValid => emailError == null && email != null && passwordError == null && password != null;
}
