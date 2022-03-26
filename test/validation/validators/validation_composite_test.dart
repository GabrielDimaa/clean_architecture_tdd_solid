import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/validation_composite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  late ValidationComposite sut;
  late FieldValidationSpy validation1;
  late FieldValidationSpy validation2;
  late FieldValidationSpy validation3;

  void mockValidation1(ValidationError? error) {
    when(() => validation1.validate(any())).thenReturn(error);
  }

  void mockValidation2(ValidationError? error) {
    when(() => validation2.validate(any())).thenReturn(error);
  }

  void mockValidation3(ValidationError? error) {
    when(() => validation3.validate(any())).thenReturn(error);
  }

  setUp(() {
    validation1 = FieldValidationSpy();
    when(() => validation1.field).thenReturn("any_field1");
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(() => validation2.field).thenReturn("any_field2");
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(() => validation3.field).thenReturn("other_field3");
    mockValidation2(null);

    sut = ValidationComposite([validation1, validation2, validation3]);
  });

  test("Deve retornar null se todas validações retornar null ou vazio", () {
    final error = sut.validate("any_field1", "any_value");

    expect(error, null);
  });

  test("Deve retornar primeiro erro", () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.requiredField);
    mockValidation3(ValidationError.invalidField);

    final error = sut.validate("any_field2", "any_value");

    expect(error, ValidationError.requiredField);
  });
}
