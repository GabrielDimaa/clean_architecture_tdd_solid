import "package:clean_architecture_tdd_solid/ui/helpers/i18n/strings/translations.dart";

class PtBr implements Translations {
  @override
  String get msgRequiredField => "Campo obrigatório.";

  @override
  String get msgEmailInUse => "O email já está em uso.";

  @override
  String get msgInvalidField => "Credenciais inválidas.";

  @override
  String get msgInvalidCredentials => "Algo errado aconteceu. Tente novamente em breve.";

  @override
  String get msgUnexpectedError => "Algo errado aconteceu. Tente novamente em breve.";

  @override
  String get addAccount => "Criar conta";

  @override
  String get confirmPassword => "Confirmar senha";

  @override
  String get email => "Email";

  @override
  String get enter => "Entrar";

  @override
  String get login => "Login";

  @override
  String get name => "Nome";

  @override
  String get password => "Senha";

  @override
  String get reload => "Recarregar";

  @override
  String get surveys => "Enquetes";

  @override
  String get surveyResult => "Resultado da enquete";

  @override
  String get wait => "Aguarde...";
}