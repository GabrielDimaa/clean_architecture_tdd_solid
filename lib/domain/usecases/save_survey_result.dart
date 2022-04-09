import '../entities/survey_result_entity.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity> save({required String answer});
}