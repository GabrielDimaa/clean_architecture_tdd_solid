import 'package:equatable/equatable.dart';

import '../../presentation/dependencies/validation.dart';
import '../dependencies/field_validation.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final String fieldToCompare;

  const CompareFieldsValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map? input) {
    return input != null && input[field] != null && input[fieldToCompare] != null &&
        input[field] != input[fieldToCompare] ? ValidationError.invalidField : null;
  }

  @override
  List<Object?> get props => [field, fieldToCompare];
}