import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/remote_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/main/factories/cache/local_storage_adapter_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';

import '../../../data/usecases/load_survey_result/local_load_survey_result.dart';
import '../../composites/remote_load_survey_result_with_local_fallback.dart';
import '../http/authorize_http_client_decorator_factory.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl("surveys/$surveyId/results"),
  );
}

LocalLoadSurveyResult makeLocalLoadSurveyResult(String surveyId) {
  return LocalLoadSurveyResult(cacheStorage: makeLocalStorageAdapter());
}

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) {
  return RemoteLoadSurveyResultWithLocalFallback(
    remote: makeRemoteLoadSurveyResult(surveyId),
    local: makeLocalLoadSurveyResult(surveyId),
  );
}
