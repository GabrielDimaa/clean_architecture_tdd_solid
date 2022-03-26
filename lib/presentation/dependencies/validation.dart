abstract class Validation {
  ValidationError? validate(String field, String value);
}

enum ValidationError {
  requiredField,
  invalidField
}