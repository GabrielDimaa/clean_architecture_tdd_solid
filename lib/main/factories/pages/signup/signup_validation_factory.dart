import 'package:clean_architecture_tdd_solid/main/builders/validation_builder.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/validation_composite.dart';

Validation makeSignUpValidation() {
  return ValidationComposite(makeSignUpValidations());
}

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.getInstance("name").requiredValidation().minValidation(3).getValidations(),
    ...ValidationBuilder.getInstance("email").requiredValidation().emailValidation().getValidations(),
    ...ValidationBuilder.getInstance("password").requiredValidation().minValidation(3).getValidations(),
    ...ValidationBuilder.getInstance("passwordConfirmation").requiredValidation().sameAs('password').getValidations(),
  ];
}
