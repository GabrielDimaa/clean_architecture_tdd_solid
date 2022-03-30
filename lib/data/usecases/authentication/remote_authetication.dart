import '../../models/remote_account_model.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient<Map?> httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final Map? response = await httpClient.request(url: url, method: "post", body: RemoteAutheticationParams.fromDomain(params).toJson());

      if (response == null) throw HttpError.invalidData;

      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
    }
  }
}

class RemoteAutheticationParams {
  final String email;
  final String password;

  RemoteAutheticationParams({required this.email, required this.password});

  factory RemoteAutheticationParams.fromDomain(AuthenticationParams params) => RemoteAutheticationParams(
        email: params.email,
        password: params.password,
      );

  Map toJson() => {'email': email, 'password': password};
}
