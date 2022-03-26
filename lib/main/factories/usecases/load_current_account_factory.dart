import 'package:clean_architecture_tdd_solid/data/usecases/load_current_account/local_fetch_current_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_current_account.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/local_storage_adapter_factory.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() {
  return LocalLoadCurrentAccount(makeLocalStorageAdapter());
}
