import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:equatable/equatable.dart';

import '../../presentation/dependencies/validation.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const EmailValidation(this.field);

  @override
  ValidationError? validate(Map? input) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final bool isValid = (input?[field] ?? "").isNotEmpty != true || regex.hasMatch(input![field]!);

    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List<Object?> get props => [field];
}