import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/main/decorators/authorize_http_client_decorator.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/secure_storage_adapter_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/http_client_factory.dart';

HttpClient makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: makeSecureStorageAdapter(),
    decoratee: makeHttpAdapter(),
  );
}
