import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';

abstract class LoadCurrentAccount {
  Future<AccountEntity?> load();
}