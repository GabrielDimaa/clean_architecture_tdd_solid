import 'dart:async';

import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_current_account.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/form_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/navigation_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/ui_error_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';
import 'package:get/get.dart';

import '../../domain/entities/account_entity.dart';
import '../../ui/helpers/errors/ui_error.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, FormManager, UIErrorManager, NavigationManager implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  GetxLoginPresenter({required this.authentication, required this.validation, required this.saveCurrentAccount});

  String? _email;
  String? _password;

  final Rxn<UIError> _emailError = Rxn<UIError>();
  final Rxn<UIError> _passwordError = Rxn<UIError>();

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  @override
  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: "email");
    _validateForm();
  }

  @override
  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: "password");
    _validateForm();
  }

  void _validateForm() {
    formValid = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  @override
  Future<void> auth() async {
    try {
      mainError = null;
      loading = true;

      final AccountEntity account = await authentication.auth(AuthenticationParams(email: _email!, password: _password!));
      await saveCurrentAccount.save(account);

      navigateTo = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError = UIError.invalidCredentials;
          break;
        default:
          mainError = UIError.unexpected;
          break;
      }
    } finally {
      loading = false;
    }
  }

  @override
  void goToSignUp() => navigateTo = "/signup";

  UIError? _validateField({required String field}) {
    final Map formData = {
      'email': _email,
      'password': _password,
    };

    final error = validation.validate(field, formData);

    switch (error) {
      case ValidationError.invalidField: return UIError.invalidField;
      case ValidationError.requiredField: return UIError.requiredField;
      default: return null;
    }
  }

  @override
  void dispose() {}
}
