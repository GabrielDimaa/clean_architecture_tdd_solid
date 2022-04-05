import 'package:clean_architecture_tdd_solid/main/builders/validation_builder.dart';
import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:clean_architecture_tdd_solid/main/composites/validation_composite.dart';

Validation makeLoginValidation() {
  return ValidationComposite(makeLoginValidations());
}

List<FieldValidation> makeLoginValidations() {
  return [
    ...ValidationBuilder.getInstance("email").requiredValidation().emailValidation().getValidations(),
    ...ValidationBuilder.getInstance("password").requiredValidation().minValidation(3).getValidations(),
  ];
}
