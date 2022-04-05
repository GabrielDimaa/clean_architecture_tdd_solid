import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_surveys.dart';
import 'package:clean_architecture_tdd_solid/main/composites/remote_load_surveys_with_local_fallback.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/local_storage_adapter_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';
import '../http/authorize_http_client_decorator_factory.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl("surveys"),
  );
}

LocalLoadSurveys makeLocalLoadSurveys() {
  return LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() {
  return RemoteLoadSurveysWithLocalFallback(remote: makeRemoteLoadSurveys(), local: makeLocalLoadSurveys());
}
