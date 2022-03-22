import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:equatable/equatable.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const EmailValidation(this.field);

  @override
  String? validate(String? value) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final bool isValid = value?.isNotEmpty != true || regex.hasMatch(value!);

    return isValid ? null : "Campo inválido.";
  }

  @override
  List<Object?> get props => [field];
}