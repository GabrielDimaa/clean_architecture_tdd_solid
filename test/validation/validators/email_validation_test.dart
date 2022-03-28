import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/email_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = const EmailValidation("any_field");
  });

  test("Deve retornar null em casos inválidos", () {
    expect(sut.validate({}), null);
  });

  test("Deve retornar null se o email for vazio", () {
    final ValidationError? error = sut.validate({'any_field': ""});

    expect(error, null);
  });

  test("Deve retornar null se o email for null", () {
    final ValidationError? error = sut.validate({'any_field': null});

    expect(error, null);
  });

  test("Deve retornar null se o email for válido", () {
    final ValidationError? result = sut.validate({'any_field': faker.internet.email()});

    expect(result, null);
  });

  test("Deve retornar null se o email for inválido", () {
    final ValidationError? result = sut.validate({'any_field': "email_error"});

    expect(result, ValidationError.invalidField);
  });
}