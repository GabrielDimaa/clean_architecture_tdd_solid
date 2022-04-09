import 'package:clean_architecture_tdd_solid/main/factories/http/api_url_factory.dart';

import '../../../data/usecases/save_survey_result/remote_save_survey_result.dart';
import '../http/authorize_http_client_decorator_factory.dart';

RemoteSaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) {
  return RemoteSaveSurveyResult(
    httpClient: makeAuthorizeHttpClientDecorator(),
    url: makeApiUrl("surveys/$surveyId/results"),
  );
}
