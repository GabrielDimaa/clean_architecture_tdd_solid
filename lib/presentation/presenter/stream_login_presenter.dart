import 'dart:async';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;

  StreamLoginPresenter({required this.authentication, required this.validation});

  StreamController<LoginState>? _controller = StreamController<LoginState>.broadcast();
  final LoginState _state = LoginState();

  @override
  Stream<String?>? get emailErrorStream => _controller?.stream.map((state) => state.emailError).distinct();

  @override
  Stream<String?>? get passwordErrorStream => _controller?.stream.map((state) => state.passwordError).distinct();

  @override
  Stream<String?>? get mainErrorStream => _controller?.stream.map((state) => state.mainError).distinct();

  @override
  Stream<bool>? get formValidStream => _controller?.stream.map((state) => state.formValid).distinct();

  @override
  Stream<bool>? get loadingStream => _controller?.stream.map((state) => state.loading).distinct();

  @override
  Stream<String?>? get navigateToStream => _controller?.stream.map((state) => state.navigateToStream).distinct();

  @override
  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate("email", email);
    _update();
  }

  @override
  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate("password", password);
    _update();
  }

  @override
  Future<void> auth() async {
    try {
      _state.loading = true;
      _update();

      await authentication.auth(AuthenticationParams(email: _state.email!, password: _state.password!));
    } on DomainError catch (error) {
      _state.mainError = error.descricao;
    } finally {
      _state.loading = false;
      _update();
    }
  }

  @override
  void dispose() {
    _controller?.close();
    _controller = null;
  }

  void _update() => _controller?.add(_state);
}

class LoginState {
  String? email;
  String? emailError;
  String? password;
  String? passwordError;
  String? mainError;
  bool loading = false;
  String? navigateToStream;

  bool get formValid => emailError == null && email != null && passwordError == null && password != null;
}
