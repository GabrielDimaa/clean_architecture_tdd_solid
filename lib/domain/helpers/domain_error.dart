enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get descricao {
    switch (this) {
      case DomainError.invalidCredentials: return "Credenciais inválidas.";
      default: return "Algo errado aconteceu. Tente novamente em breve.";
    }
  }
}
