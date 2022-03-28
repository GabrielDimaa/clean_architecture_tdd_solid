import '../../presentation/dependencies/validation.dart';

abstract class FieldValidation {
  String get field;

  ValidationError? validate(Map? input);
}