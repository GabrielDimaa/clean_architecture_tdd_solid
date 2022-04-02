import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_presenter.dart';
import '../../../../presentation/presenter/get_survey_presenter.dart';
import '../../usecases/load_surveys_factory.dart';

SurveysPresenter makeGetxSurveyPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
}
