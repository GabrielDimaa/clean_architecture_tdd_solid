import 'package:clean_architecture_tdd_solid/ui/helpers/i18n/resources.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse
}

extension UIErrorExtension on UIError {
  String get descricao {
    switch (this) {
      case UIError.requiredField: return R.strings.msgRequiredField;
      case UIError.invalidField: return R.strings.msgInvalidField;
      case UIError.invalidCredentials: return R.strings.msgInvalidCredentials;
      case UIError.emailInUse: return R.strings.msgEmailInUse;
      default: return R.strings.msgUnexpectedError;
    }
  }
}