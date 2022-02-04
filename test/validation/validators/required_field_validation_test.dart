import 'package:clean_architecture_tdd_solid/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation("any_field");
  });

  test("Deve retornar null se o valor não for vazio", () {
    final String? error = sut.validate("any_value");

    expect(error, null);
  });

  test("Deve retornar erro se o valor for vazio", () {
    final String? error = sut.validate("");

    expect(error, "Campo obrigatório.");
  });

  test("Deve retornar erro se o valor for null", () {
    final String? error = sut.validate(null);

    expect(error, "Campo obrigatório.");
  });
}