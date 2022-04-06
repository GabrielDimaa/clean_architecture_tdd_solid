import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';

abstract class LoadSurveyResult {
  Future<SurveyResultEntity> loadBySurvey({String? surveyId});
}