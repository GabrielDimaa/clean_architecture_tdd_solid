abstract class Validation {
  ValidationError? validate(String field, Map input);
}

enum ValidationError {
  requiredField,
  invalidField
}