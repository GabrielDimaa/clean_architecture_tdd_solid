import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/usecases.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/helpers.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fake_account_factory.dart';
import '../../../mocks/fake_params_factory.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  late Map apiResult;

  When mockRequest() => when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')));

  void mockHttpData(Map data) {
    apiResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = FakeParamsFactory.makeAuthentication();

    mockHttpData(FakeAccountFactory.makeApiJson());
  });

  test("Deve chamar HttpClient com a URL correta", () async {
    await sut.auth(params);

    verify(() => httpClient.request(url: url, method: "post", body: {'email': params.email, 'password': params.password}));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 400", () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 500", () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw InvalidCredentialsError se HttpClient retornar 401", () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test("Deve retornar um Account se HttpClient retornar 200", () async {
    final AccountEntity account = await sut.auth(params);

    expect(account.token, apiResult['accessToken']);
  });

  test("Deve throw UnexpectedError se HttpClient retornar 200 com dados inválidos", () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
