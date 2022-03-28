import 'dart:async';

import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/add_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_current_account.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/signup/signup_presenter.dart';
import 'package:get/get.dart';

import '../../domain/entities/account_entity.dart';
import '../../ui/helpers/errors/ui_error.dart';

class GetxSignUpPresenter extends GetxController implements SignUpPresenter {
  final AddAccount addAccount;
  final Validation validation;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({required this.addAccount, required this.validation, required this.saveCurrentAccount});

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  final Rxn<UIError> _nameError = Rxn<UIError>();
  final Rxn<UIError> _emailError = Rxn<UIError>();
  final Rxn<UIError> _passwordError = Rxn<UIError>();
  final Rxn<UIError> _passwordConfirmationError = Rxn<UIError>();
  final Rxn<UIError> _mainError = Rxn<UIError>();
  final RxBool _formValid = false.obs;
  final RxBool _loading = false.obs;
  final RxnString _navigateToStream = RxnString();

  @override
  Stream<UIError?> get nameErrorStream => _nameError.stream;

  @override
  Stream<UIError?> get emailErrorStream => _emailError.stream;

  @override
  Stream<UIError?> get passwordErrorStream => _passwordError.stream;

  @override
  Stream<UIError?> get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  @override
  Stream<UIError?> get mainErrorStream => _mainError.stream;

  @override
  Stream<bool> get formValidStream => _formValid.stream;

  @override
  Stream<bool> get loadingStream => _loading.stream;

  @override
  Stream<String?> get navigateToStream => _navigateToStream.stream;

  @override
  void goToLogin() => _navigateToStream.value = "/login";

  @override
  Future<void> signUp() async {
    try {
      _mainError.value = null;
      _loading.value = true;

      final AccountEntity account = await addAccount.add(AddAccountParams(
        name: _name!,
        email: _email!,
        password: _password!,
        passwordConfirmation: _passwordConfirmation!,
      ));

      await saveCurrentAccount.save(account);

      _navigateToStream.value = "/surveys";
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          _mainError.value = UIError.emailInUse;
          break;
        default:
          _mainError.value = UIError.unexpected;
      }
    } finally {
      _loading.value = false;
    }
  }

  @override
  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: "name");
    _validateForm();
  }

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

  @override
  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(field: "passwordConfirmation");
    _validateForm();
  }

  void _validateForm() {
    _formValid.value = _nameError.value == null &&
        _emailError.value == null &&
        _passwordError.value == null &&
        _passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _password != null &&
        _passwordConfirmation != null;
  }

  UIError? _validateField({required String field}) {
    final formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };

    final error = validation.validate(field, formData);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  @override
  void dispose() {}
}
