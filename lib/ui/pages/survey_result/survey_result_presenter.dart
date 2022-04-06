import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:flutter/cupertino.dart';

abstract class SurveyResultPresenter implements Listenable {
  Stream<bool> get loadingStream;
  Stream<bool> get sessionExpiredStream;
  Stream<SurveyResultViewModel?> get surveyResultStream;

  Future<void> loadData();
  Future<void> save({required String answer});
}