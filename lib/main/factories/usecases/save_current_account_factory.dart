import 'package:clean_architecture_tdd_solid/data/usecases/authentication/remote_authetication.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/local_storage_adapter_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/http_client_factory.dart';

LocalSaveCurrentAccount makeCurrentAccount() {
  return LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
}
