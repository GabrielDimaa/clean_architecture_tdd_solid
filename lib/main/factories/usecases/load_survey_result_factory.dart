import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/remote_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';

import '../http/authorize_http_client_decorator_factory.dart';

RemoteLoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) {
  return RemoteLoadSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl("surveys/$surveyId/results"),
  );
}
