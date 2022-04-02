abstract class CacheStorage {
  Future<dynamic> fetch(String key);
  Future<void> delete(String key);
  Future<void> save({required String key, required List<Map<String, String>> value});
}