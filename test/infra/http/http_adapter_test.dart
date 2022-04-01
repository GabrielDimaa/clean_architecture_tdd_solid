import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/infra/http/http.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpsUrl();

    registerFallbackValue(Uri.parse(url));
  });

  group("post", () {
    When mockRequest() {
      return when(() {
        return client.post(any(), headers: any(named: "headers"), body: any(named: "body"));
      });
    }

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() => mockResponse(200));

    test("Deve chamar post com valores corretos", () async {
      await sut.request(url: url, method: "post", body: {'any_key': 'any_value'});

      verify(() => client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json',
            },
            body: '{"any_key":"any_value"}',
          ));
    });

    test("Deve retornar data se o post for 200", () async {
      final Map? response = await sut.request(url: url, method: "post");

      expect(response, {'any_key': 'any_value'});
    });

    test("Deve retornar null se o post for 200 sem data", () async {
      mockResponse(200, body: "");

      final Map? response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Deve retornar null se o post for 204 e data vazio", () async {
      mockResponse(204, body: "");

      final Map? response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Deve retornar null se o post for 204 e com data", () async {
      mockResponse(204);

      final Map? response = await sut.request(url: url, method: "post");

      expect(response, null);
    });

    test("Deve retornar BadRequestError se o post for 400", () async {
      mockResponse(400);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Deve retornar BadRequestError se o post for 400", () async {
      mockResponse(400, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Deve retornar ServerError se o post for 500", () async {
      mockResponse(500);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });

    test("Deve retornar ServerError se o post for 500", () async {
      mockResponse(500, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.serverError));
    });

    test("Deve retornar UnauthorizedError se o post for 401", () async {
      mockResponse(401);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Deve retornar UnauthorizedError se o post for 401", () async {
      mockResponse(401, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Deve retornar ForbidenError se o post for 403", () async {
      mockResponse(403);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.forbidden));
    });

    test("Deve retornar ForbidenError se o post for 403", () async {
      mockResponse(403, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.forbidden));
    });

    test("Deve retornar NotFoundError se o post for 404", () async {
      mockResponse(404);

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.notFound));
    });

    test("Deve retornar NotFoundError se o post for 404", () async {
      mockResponse(404, body: "");

      final future = sut.request(url: url, method: "post");

      expect(future, throwsA(HttpError.notFound));
    });

    test("Deve retornar ServerError se o post throws", () async {
      mockError();

      final future = sut.request(url: url, method: "invalid method");

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group("get", () {
    When mockRequest() {
      return when(() {
        return client.get(any(), headers: any(named: "headers"));
      });
    }

    void mockResponse(int statusCode, {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      mockRequest().thenThrow(Exception());
    }

    setUp(() => mockResponse(200));

    test("Deve chamar get com valores corretos", () async {
      await sut.request(url: url, method: "get", body: {'any_key': 'any_value'});

      verify(() => client.get(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        }
      ));
    });

    test("Deve retornar data se o get for 200", () async {
      final Map? response = await sut.request(url: url, method: "get");

      expect(response, {'any_key': 'any_value'});
    });

    test("Deve retornar null se o get for 200 sem data", () async {
      mockResponse(200, body: "");

      final Map? response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Deve retornar null se o get for 204 e data vazio", () async {
      mockResponse(204, body: "");

      final Map? response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Deve retornar null se o get for 204 e com data", () async {
      mockResponse(204);

      final Map? response = await sut.request(url: url, method: "get");

      expect(response, null);
    });

    test("Deve retornar BadRequestError se o get for 400", () async {
      mockResponse(400);

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Deve retornar BadRequestError se o get for 400", () async {
      mockResponse(400, body: "");

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.badRequest));
    });

    test("Deve retornar ServerError se o get for 500", () async {
      mockResponse(500);

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.serverError));
    });

    test("Deve retornar UnauthorizedError se o get for 401", () async {
      mockResponse(401);

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.unauthorized));
    });

    test("Deve retornar ForbidenError se o get for 403", () async {
      mockResponse(403);

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.forbidden));
    });

    test("Deve retornar NotFoundError se o get for 404", () async {
      mockResponse(404);

      final future = sut.request(url: url, method: "get");

      expect(future, throwsA(HttpError.notFound));
    });

    test("Deve retornar ServerError se o get throws", () async {
      mockError();

      final future = sut.request(url: url, method: "invalid method");

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group("shared", () {
    test("Deve retornar ServerError se o método é inválido", () async {
      final future = sut.request(url: url, method: "invalid method");

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
