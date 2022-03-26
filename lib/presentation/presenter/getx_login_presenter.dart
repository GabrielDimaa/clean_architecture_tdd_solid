import 'dart:async';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_current_account.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';
import 'package:get/get.dart';

import '../../domain/entities/account_entity.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({required this.authentication, required this.validation, required this.saveCurrentAccount});

  String? _email;
  String? _password;

  final RxnString _emailError = RxnString();
  final RxnString _passwordError = RxnString();
  final RxnString _mainError = RxnString();
  final RxBool _formValid = false.obs;
  final RxBool _loading = false.obs;
  final RxnString _navigateToStream = RxnString();

  @override
  Stream<String?>? get emailErrorStream => _emailError.stream;

  @override
  Stream<String?>? get passwordErrorStream => _passwordError.stream;

  @override
  Stream<String?>? get mainErrorStream => _mainError.stream;

  @override
  Stream<bool>? get formValidStream => _formValid.stream;

  @override
  Stream<bool>? get loadingStream => _loading.stream;

  @override
  Stream<String?>? get navigateToStream => _navigateToStream.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate("email", email);
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate("password", password);
    _validateForm();
  }

  void _validateForm() {
    _formValid.value = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      _loading.value = true;

      final AccountEntity account = await authentication.auth(AuthenticationParams(email: _email!, password: _password!));
      await saveCurrentAccount.save(account);

      _navigateToStream.value = "/surveys";
    } on DomainError catch (error) {
      _mainError.value = error.descricao;
    } finally {
      _loading.value = false;
    }
  }

  @override
  void dispose() {}
}

class LoginState {
  String? email;
  String? emailError;
  String? password;
  String? passwordError;
  String? mainError;
  bool loading = false;

  bool get formValid => emailError == null && email != null && passwordError == null && password != null;
}