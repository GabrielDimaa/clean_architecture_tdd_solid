import 'package:clean_architecture_tdd_solid/ui/pages/surveys/surveys_presenter.dart';

import '../../../../presentation/presenter/getx_surveys_presenter.dart';
import '../../usecases/load_surveys_factory.dart';

SurveysPresenter makeGetxSurveyPresenter() {
  return GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveysWithLocalFallback());
}
