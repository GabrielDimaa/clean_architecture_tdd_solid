import 'package:clean_architecture_tdd_solid/infra/cache/local_storage_adapter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

LocalStorageAdapter makeLocalStorageAdapter() {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  return LocalStorageAdapter(secureStorage: secureStorage);
}
