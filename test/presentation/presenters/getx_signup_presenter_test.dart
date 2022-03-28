import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/add_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_current_account.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_signup_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late ValidationSpy validation;
  late GetxSignUpPresenter sut;
  late AddAccountSpy addAccount;
  late SaveCurrentAccount saveCurrentAccount;
  late String name;
  late String email;
  late String password;
  late String passwordConfirmation;
  late String token;

  When mockValidationCall({String? field}) => when(() => validation.validate(field ?? any(), any()));

  When mockAddAccountCall({String? field}) => when(() => addAccount.add(AddAccountParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      )));

  When mockSaveCurrentAccountCall() => when(() => saveCurrentAccount.save(AccountEntity(token)));

  void mockValidation({String? field, String? value}) => mockValidationCall(field: field).thenReturn(value);

  void mockValidationError({String? field, required ValidationError value}) => mockValidationCall(field: field).thenReturn(value);

  void mockAddAccount() => mockAddAccountCall().thenAnswer((_) async => AccountEntity(token));

  void mockAddAccountError(DomainError error) => mockAddAccountCall().thenThrow(error);

  void mockSaveCurrentAccount() => mockSaveCurrentAccountCall().thenAnswer((_) => Future.value());

  void mockSaveCurrentAccountError() => mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxSignUpPresenter(addAccount: addAccount, validation: validation, saveCurrentAccount: saveCurrentAccount);
    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAddAccount();
    mockSaveCurrentAccount();
  });

  test("Deve chamar validation ao alterar email", () {
    final Map formData = {
      'name': null,
      'email': email,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateEmail(email);

    verify(() => validation.validate("email", formData)).called(1);
  });

  test("Deve emitir erro se o email for inválido", () {
    mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve emitir erro se o email for vazio", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve emitir null se a validação do email for sucesso", () {
    sut.emailErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve chamar validation ao alterar nome", () {
    final Map formData = {
      'name': name,
      'email': null,
      'password': null,
      'passwordConfirmation': null,
    };

    sut.validateName(name);

    verify(() => validation.validate("name", formData)).called(1);
  });

  test("Deve emitir erro se o nome for inválido", () {
    mockValidationError(value: ValidationError.invalidField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test("Deve emitir erro se o nome for vazio", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test("Deve emitir null se a validação do nome for sucesso", () {
    sut.nameErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test("Deve chamar validation ao alterar senha", () {
    final Map formData = {
      'name': null,
      'email': null,
      'password': password,
      'passwordConfirmation': null,
    };

    sut.validatePassword(password);

    verify(() => validation.validate("password", formData)).called(1);
  });

  test("Deve emitir erro se a senha for inválido", () {
    mockValidationError(value: ValidationError.invalidField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Deve emitir erro se a senha for vazio", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Deve emitir null se a validação da senha for sucesso", () {
    sut.passwordErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Deve chamar validation ao alterar confirme senha", () {
    final Map formData = {
      'name': null,
      'email': null,
      'password': null,
      'passwordConfirmation': passwordConfirmation,
    };

    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(() => validation.validate("passwordConfirmation", formData)).called(1);
  });

  test("Deve emitir erro se confirme senha for inválido", () {
    mockValidationError(value: ValidationError.invalidField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test("Deve emitir erro se confirme senha for vazio", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test("Deve emitir null se a validação de confirme senha for sucesso", () {
    sut.passwordConfirmationErrorStream.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test("Deve validar o formulário se todos os campos forem válidos", () async {
    expectLater(sut.formValidStream, emitsInOrder([false, true]));

    sut.validateName(name);
    await Future.delayed(Duration.zero);
    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
  });

  test('Deve chamar AddAccount com valores corretos', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    AddAccountParams params = AddAccountParams(name: name, email: email, password: password, passwordConfirmation: passwordConfirmation);
    verify(() => addAccount.add(params)).called(1);
  });

  test('Deve chamar SaveCurrentAccount com valores corretos', () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    await sut.signUp();

    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emitir UnexpectedError se SaveCurrentAccount falhar', () async {
    mockSaveCurrentAccountError();

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.loadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test("Deve emitir evento correto quando sucesso no AddAccount", () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emits(null));
    expectLater(sut.loadingStream, emits(true));

    await sut.signUp();
  });

  test("Deve emitir evento correto quando EmailInUse", () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.emailInUse]));
    expectLater(sut.loadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test("Deve emitir evento correto quando UnexpectedError", () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    expectLater(sut.mainErrorStream, emitsInOrder([null, UIError.unexpected]));
    expectLater(sut.loadingStream, emitsInOrder([true, false]));

    await sut.signUp();
  });

  test("Deve alterar Page em caso de sucesso", () async {
    sut.validateName(name);
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test("Deve ir para LoginPage", () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, '/login')));

    sut.goToLogin();
  });
}
