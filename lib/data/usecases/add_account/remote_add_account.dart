import 'package:clean_architecture_tdd_solid/domain/usecases/add_account.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../http/http.dart';
import '../../models/remote_account_model.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    try {
      final Map? response = await httpClient.request(
        url: url,
        method: "post",
        body: RemoteAddAccountParams.fromDomain(params).toJson(),
      );

      if (response == null) throw HttpError.invalidData;

      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.emailInUse : DomainError.unexpected;
    }
  }
}

class RemoteAddAccountParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RemoteAddAccountParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  factory RemoteAddAccountParams.fromDomain(AddAccountParams params) => RemoteAddAccountParams(
        name: params.name,
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
      );

  Map toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'passwordConfirmation': passwordConfirmation,
      };
}
