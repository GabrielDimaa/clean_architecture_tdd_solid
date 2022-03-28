import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_current_account.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_login_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  late ValidationSpy validation;
  late GetxLoginPresenter sut;
  late AuthenticationSpy authentication;
  late SaveCurrentAccount saveCurrentAccount;
  late String email;
  late String password;
  late String token;

  When mockValidationCall({String? field}) => when(() => validation.validate(field ?? any(), any()));

  When mockAuthenticationCall({String? field}) => when(() => authentication.auth(AuthenticationParams(email: email, password: password)));

  When mockSaveCurrentAccountCall() => when(() => saveCurrentAccount.save(AccountEntity(token)));

  void mockValidation({String? field, String? value}) => mockValidationCall(field: field).thenReturn(value);

  void mockValidationError({String? field, required ValidationError value}) => mockValidationCall(field: field).thenReturn(value);

  void mockAuthentication() => mockAuthenticationCall().thenAnswer((_) async => AccountEntity(token));

  void mockAuthenticationError(DomainError error) => mockAuthenticationCall().thenThrow(error);

  void mockSaveCurrentAccount() => mockSaveCurrentAccountCall().thenAnswer((_) => Future.value());

  void mockSaveCurrentAccountError() => mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();
    sut = GetxLoginPresenter(validation: validation, authentication: authentication, saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();

    mockValidation();
    mockAuthentication();
    mockSaveCurrentAccount();
  });

  test("Deve chamar validation ao alterar email", () {
    sut.validateEmail(email);

    verify(() => validation.validate("email", email)).called(1);
  });

  test("Deve emitir erro se o email for inválido", () {
    mockValidationError(value: ValidationError.invalidField);

    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve emitir erro se o email for vazio", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve emitir null se a validação do email for sucesso", () {
    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test("Deve chamar validation ao alterar senha", () {
    sut.validatePassword(password);

    verify(() => validation.validate("password", password)).called(1);
  });

  test("Deve emitir erro se a senha for vazia", () {
    mockValidationError(value: ValidationError.requiredField);

    sut.passwordErrorStream?.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Deve emitir null se a validação da senha for sucesso", () {
    sut.passwordErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test("Deve invalidar o formulário se a validação do email falhar", () {
    mockValidationError(field: "email", value: ValidationError.invalidField);

    sut.formValidStream?.listen(expectAsync1((valid) => expect(valid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test("Deve validar o formulário se a validação do email e senha for sucesso", () async {
    sut.emailErrorStream?.listen(expectAsync1((error) => expect(error, null)));
    sut.passwordErrorStream?.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.formValidStream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test("Deve chamar authentication com valores corretos", () async {
    when(() => saveCurrentAccount.save(AccountEntity(token))).thenAnswer((_) => Future.value());

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => authentication.auth(AuthenticationParams(email: email, password: password))).called(1);
  });

  test("Deve emitir UnexpectedError se SaveCurrentAccount falhar", () async {
    mockSaveCurrentAccountError();

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test("Deve chamar SaveCurrentAccount com valores corretos", () async {
    when(() => saveCurrentAccount.save(AccountEntity(token))).thenAnswer((_) => Future.value());

    sut.validateEmail(email);
    sut.validatePassword(password);

    await sut.auth();

    verify(() => saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test("Deve emitir evento correto quando sucesso na authentication", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.loadingStream, emitsInOrder([true, false]));

    await sut.auth();
  });

  test("Deve emitir evento correto quando InvalidCredentialsError", () async {
    mockAuthenticationError(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen(expectAsync1((error) => expect(error, UIError.invalidCredentials)));

    await sut.auth();
  });

  test("Deve emitir evento correto quando UnexpectedError", () async {
    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.mainErrorStream?.listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.auth();
  });

  test("Deve alterar Page em caso de sucesso", () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateToStream?.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test("Deve ir para SignUpPage", () async {
    sut.navigateToStream?.listen(expectAsync1((page) => expect(page, "/signup")));
    sut.goToSignUp();
  });
}
