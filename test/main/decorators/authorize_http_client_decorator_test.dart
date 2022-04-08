import 'package:clean_architecture_tdd_solid/data/cache/delete_secure_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/main/decorators/authorize_http_client_decorator.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

class DeleteSecureCacheStorageSpy extends Mock implements DeleteSecureCacheStorage {}

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late AuthorizeHttpClientDecorator sut;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late DeleteSecureCacheStorageSpy deleteSecureCacheStorage;
  late HttpClientSpy httpClient;
  late String url;
  late String method;
  late Map<String, dynamic> body;
  late String token;
  late String httpResponse;

  When mockFetchSecureCall() => when(() => fetchSecureCacheStorage.fetch(any()));

  When mockDeleteSecureCall() => when(() => deleteSecureCacheStorage.delete(any()));

  When mockHttpResponseCall() => when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ));

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  void mockFetchSecure() {
    token = faker.guid.guid();
    mockFetchSecureCall().thenAnswer((_) => Future.value(token));
  }

  void mockDeleteSecure() {
    mockDeleteSecureCall().thenAnswer((_) => Future.value());
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(10);
    mockHttpResponseCall().thenAnswer((_) => Future.value(httpResponse));
  }

  void mockHttpResponseError(HttpError error) {
    mockHttpResponseCall().thenThrow(error);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    deleteSecureCacheStorage = DeleteSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      deleteSecureCacheStorage: deleteSecureCacheStorage,
      decoratee: httpClient,
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};

    mockFetchSecure();
    mockDeleteSecure();
    mockHttpResponse();
  });

  test("Deve chamar FetchSecureCacheStorage com chave correta", () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => fetchSecureCacheStorage.fetch('token')).called(1);
  });

  test("Deve chamar decoratee com token de acesso em header", () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token})).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_key': 'any_value'});
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token, 'any_key': 'any_value'})).called(1);
  });

  test("Deve retornar mesmo resultado do decoratee", () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test("Deve throw ForbiddenError se FetchSecureCacheStorage throws", () async {
    mockFetchSecureError();

    final Future future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
    verify(() => deleteSecureCacheStorage.delete("token")).called(1);
  });

  test("Deve rethrow decoratee throws", () async {
    mockHttpResponseError(HttpError.badRequest);

    final Future future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.badRequest));
  });

  test("Deve deletar cache se requisição throws ForbiddenError", () async {
    mockHttpResponseError(HttpError.forbidden);

    final Future future = sut.request(url: url, method: method, body: body);
    await untilCalled(() => deleteSecureCacheStorage.delete("token"));

    expect(future, throwsA(HttpError.forbidden));
    verify(() => deleteSecureCacheStorage.delete("token")).called(1);
  });
}
