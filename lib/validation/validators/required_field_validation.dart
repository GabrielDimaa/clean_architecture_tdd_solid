import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:equatable/equatable.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  const RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return "Campo obrigatório.";
    }

    return null;
  }

  @override
  List<Object?> get props => [field];
}
