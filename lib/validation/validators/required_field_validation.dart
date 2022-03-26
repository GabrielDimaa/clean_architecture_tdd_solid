import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:equatable/equatable.dart';

import '../../presentation/dependencies/validation.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return ValidationError.requiredField;
    }

    return null;
  }

  @override
  List<Object?> get props => [field];
}
