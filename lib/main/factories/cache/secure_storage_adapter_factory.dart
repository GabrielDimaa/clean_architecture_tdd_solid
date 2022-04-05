import 'package:clean_architecture_tdd_solid/infra/cache/secure_storage_adapter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

SecureStorageAdapter makeSecureStorageAdapter() {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  return SecureStorageAdapter(secureStorage: secureStorage);
}
