import 'package:clean_architecture_tdd_solid/data/usecases/remote_authetication.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/authentication.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/http_client_factory.dart';

Authentication makeRemoteAuthentication() {
  return RemoteAuthentication(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl("login"),
  );
}
