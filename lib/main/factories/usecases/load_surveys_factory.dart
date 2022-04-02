import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_surveys.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';
import '../http/authorize_http_client_decorator_factory.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl("surveys"),
  );
}
