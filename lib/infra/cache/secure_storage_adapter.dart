import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/cache/delete_secure_cache_storage.dart';
import '../../data/cache/fetch_secure_cache_storage.dart';
import '../../data/cache/save_secure_cache_storage.dart';

class SecureStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage, DeleteSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  SecureStorageAdapter({required this.secureStorage});

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> fetch(String key) async {
    return await secureStorage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await secureStorage.delete(key: key);
  }
}