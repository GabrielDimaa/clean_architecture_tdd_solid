import 'package:clean_architecture_tdd_solid/data/usecases/add_account/remote_add_account.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/add_account.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/http_client_factory.dart';

AddAccount makeRemoteAddAccount() {
  return RemoteAddAccount(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl("signup"),
  );
}
