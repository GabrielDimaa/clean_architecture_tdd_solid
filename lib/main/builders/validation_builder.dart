import 'package:clean_architecture_tdd_solid/validation/dependencies/field_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/email_validation.dart';
import 'package:clean_architecture_tdd_solid/validation/validators/required_field_validation.dart';

class ValidationBuilder {
  late String _fieldName;
  final List<FieldValidation> _validations = [];

  ValidationBuilder._();

  static late ValidationBuilder _instance;

  static ValidationBuilder getInstance (String fieldName) {
    _instance = ValidationBuilder._();
    _instance._fieldName = fieldName;

    return _instance;
  }

  ValidationBuilder requiredValidation() {
    _instance._validations.add(RequiredFieldValidation(_fieldName));

    return _instance;
  }

  ValidationBuilder setEmailValidation() {
    _instance._validations.add(EmailValidation(_fieldName));

    return _instance;
  }

  List<FieldValidation> getValidations() => _validations;
}