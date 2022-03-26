import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String token;

  const AccountEntity(this.token);

  @override
  List<Object?> get props => [token];
}