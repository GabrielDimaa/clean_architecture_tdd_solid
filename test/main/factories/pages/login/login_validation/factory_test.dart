import 'package:clean_architecture_tdd_solid/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/email_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/min_length_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/required_field_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Deve retornar as validações corretas", () {
    final validations = makeLoginValidations();

    expect(validations, [
      const RequiredFieldValidation("email"),
      const EmailValidation("email"),
      const RequiredFieldValidation("password"),
      const MinLengthValidation(field: "password", size: 3),
    ]);
  });
}