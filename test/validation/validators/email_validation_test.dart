import 'package:clean_architecture_tdd_solid/validation/validators/email_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = const EmailValidation("any_field");
  });

  test("Deve retornar null se o email for vazio", () {
    final String? error = sut.validate("");

    expect(error, null);
  });

  test("Deve retornar null se o email for null", () {
    final String? error = sut.validate(null);

    expect(error, null);
  });

  test("Deve retornar null se o email for válido", () {
    final String? result = sut.validate(faker.internet.email());

    expect(result, null);
  });

  test("Deve retornar null se o email for inválido", () {
    final String? result = sut.validate("email_error");

    expect(result, "Campo inválido.");
  });
}