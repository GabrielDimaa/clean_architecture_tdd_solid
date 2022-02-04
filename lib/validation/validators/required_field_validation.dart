import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';

class RequiredFieldValidation implements FieldValidation {
  @override
  final String field;

  RequiredFieldValidation(this.field);

  @override
  String? validate(String? value) {
    if (value?.isEmpty ?? true) {
      return "Campo obrigatório.";
    }

    return null;
  }
}
