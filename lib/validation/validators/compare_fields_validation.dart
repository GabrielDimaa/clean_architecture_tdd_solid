import '../../presentation/dependencies/validation.dart';
import '../dependencies/field_validation.dart';

class CompareFieldsValidation implements FieldValidation {
  @override
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map? input) {
    return input != null && input[field] != null && input[fieldToCompare] != null &&
        input[field] != input[fieldToCompare] ? ValidationError.invalidField : null;
  }
}