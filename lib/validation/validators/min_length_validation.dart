import 'package:clean_architecture_tdd_solid/presentation/dependencies/validation.dart';
import 'package:equatable/equatable.dart';

import '../dependencies/field_validation.dart';

class MinLengthValidation extends Equatable implements FieldValidation {
  @override
  final String field;
  final int size;

  const MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validate(Map? input) {
    return input?[field] != null && input?[field].length >= size ? null : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [field, size];
}