import 'package:clean_architecture_tdd_solid/main/factories/pages/signup/signup_validation_factory.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/compare_fields_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/email_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/min_length_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Deve retornar as validações corretas", () {
    final validations = makeSignUpValidations();

    expect(validations, [
      const RequiredFieldValidation("name"),
      const MinLengthValidation(field: "name", size: 3),
      const RequiredFieldValidation("email"),
      const EmailValidation("email"),
      const RequiredFieldValidation("password"),
      const MinLengthValidation(field: "password", size: 3),
      const RequiredFieldValidation("passwordConfirmation"),
      const CompareFieldsValidation(field: "passwordConfirmation", fieldToCompare: "password"),
    ]);
  });
}