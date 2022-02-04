import '../entities/entities.dart';
import 'package:equatable/equatable.dart';

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}

class AuthenticationParams extends Equatable {
  final String email;
  final String password;

  const AuthenticationParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}