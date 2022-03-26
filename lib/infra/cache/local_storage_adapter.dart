import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/cache/fetch_secure_cache_storage.dart';
import '../../data/cache/save_secure_cache_storage.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage, FetchSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  @override
  Future<void> saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<String?> fetchSecure(String key) async {
    return await secureStorage.read(key: key);
  }
}