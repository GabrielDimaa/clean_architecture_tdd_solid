import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/min_length_validation.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = const MinLengthValidation(field: "any_field", size: 5);
  });

  test("Deve retornar erro se valor for vazio", () {
    expect(sut.validate({'any_field': ""}), ValidationError.invalidField);
  });

  test("Deve retornar erro se valor for null", () {
    expect(sut.validate({'any_field': null}), ValidationError.invalidField);
  });

  test("Deve retornar erro se valor for menor que o tamanho mínimo", () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}), ValidationError.invalidField);
  });

  test("Deve retornar null se valor for igual ao tamanho mínimo", () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}), null);
  });

  test("Deve retornar null se valor for maior que tamanho mínimo", () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(10, min: 5)}), null);
  });
}