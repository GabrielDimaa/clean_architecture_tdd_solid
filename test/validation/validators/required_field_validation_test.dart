import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = const RequiredFieldValidation("any_field");
  });

  test("Deve retornar null se o valor não for vazio", () {
    final ValidationError? error = sut.validate("any_value");

    expect(error, null);
  });

  test("Deve retornar erro se o valor for vazio", () {
    final ValidationError? error = sut.validate("");

    expect(error, ValidationError.requiredField);
  });

  test("Deve retornar erro se o valor for null", () {
    final ValidationError? error = sut.validate(null);

    expect(error, ValidationError.requiredField);
  });
}