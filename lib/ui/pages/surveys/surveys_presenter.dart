import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_view_model.dart';
import 'package:flutter/cupertino.dart';

abstract class SurveysPresenter implements Listenable {
  Stream<bool> get loadingStream;
  Stream<bool> get sessionExpiredStream;
  Stream<List<SurveyViewModel>> get surveysStream;
  Stream<String?> get navigateToStream;

  Future<void> loadData();
  void goToSurveyResult(String surveyId);
}