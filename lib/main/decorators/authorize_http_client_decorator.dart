import 'package:clean_architecture_tdd_solid/data/http/http_client.dart';
import '../../data/cache/fetch_secure_cache_storage.dart';
import '../../data/http/http_error.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage, required this.decoratee});

  @override
  Future<dynamic> request({required String url, required String method, Map? body, Map<String, String>? headers}) async {
    try {
      final String? token = await fetchSecureCacheStorage.fetchSecure('token');

      final Map<String, String> authorizedHeaders = headers ?? {}
        ..addAll({'x-access-token': token ?? ""});
      return await decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
    } on HttpError {
      rethrow;
    } catch (error) {
      throw HttpError.forbidden;
    }
  }
}