import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/compare_fields_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = const CompareFieldsValidation(field: "any_field", fieldToCompare: "other_field");
  });

  test("Deve retornar erro se o valor não for igual", () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test("Deve retornar erro se o valor não for igual", () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};
    expect(sut.validate(formData), null);
  });

  test("Deve retornar erro em casos inválidos", () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });
}