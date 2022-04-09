import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_presenter.dart';

import '../../../../presentation/presenter/getx_survey_result_presenter.dart';
import '../../usecases/load_survey_result_factory.dart';

SurveyResultPresenter makeGetxSurveyResultPresenter(String surveyId) {
  return GetxSurveyResultPresenter(
    loadSurveyResult: makeRemoteLoadSurveyResultWithLocalFallback(surveyId),
    surveyId: surveyId,
  );
}
