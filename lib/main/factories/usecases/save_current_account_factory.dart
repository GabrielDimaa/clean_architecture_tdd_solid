import 'package:clean_architecture_tdd_solid/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/local_storage_adapter_factory.dart';

LocalSaveCurrentAccount makeSaveCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
}
