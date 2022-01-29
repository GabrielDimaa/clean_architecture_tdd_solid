import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AutheticationParams params);
}

class AutheticationParams {
  final String email;
  final String password;

  AutheticationParams({required this.email, required this.password});
}