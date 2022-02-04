import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String? validate(String field, String value) {
    String? error;

    for (var e in validations.where((e) => e.field == field)) {
      error = e.validate(value);

      if (error?.isNotEmpty ?? false) {
        return error;
      }
    }

    return error;
  }
}