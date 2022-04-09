import 'dart:convert';
import 'package:http/http.dart';
import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map?> request({required String url, required String method, Map? body, Map<String, String>? headers}) async {
    final defaultHeaders = headers ?? {}..addAll({
      'content-type': 'application/json',
      'accept': 'application/json',
    });

    final bodyJson = body != null ? jsonEncode(body) : null;

    Response response = Response("", 500);

    try {
      switch (method) {
        case "post":
          response = await client.post(Uri.parse(url), headers: defaultHeaders, body: bodyJson).timeout(const Duration(seconds: 10));
          break;
        case "put":
          response = await client.put(Uri.parse(url), headers: defaultHeaders, body: bodyJson).timeout(const Duration(seconds: 10));
          break;
        case "get":
          response = await client.get(Uri.parse(url), headers: defaultHeaders).timeout(const Duration(seconds: 10));
          break;
      }
    } catch (e) {
      throw HttpError.serverError;
    }

    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        if (response.body.isNotEmpty) {
          return jsonDecode(response.body);
        } else {
          return null;
        }
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      case 500:
        throw HttpError.serverError;
      default:
        throw HttpError.serverError;
    }
  }
}
