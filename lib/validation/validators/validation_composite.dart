import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  ValidationError? validate(String field, Map input) {
    ValidationError? error;

    for (var e in validations.where((e) => e.field == field)) {
      error = e.validate(input);

      if (error != null) {
        return error;
      }
    }

    return error;
  }
}