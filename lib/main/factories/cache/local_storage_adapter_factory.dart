import 'package:clean_architecture_tdd_solid/infra/cache/local_storage_adapter.dart';
import 'package:localstorage/localstorage.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  return LocalStorageAdapter(localStorage: LocalStorage("fordev"));
}
