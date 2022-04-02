import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';

abstract class LoadSurveys {
  Future<List<SurveyEntity>> load();
  Future<void> validate();
  Future<void> save(List<SurveyEntity> surveys);
}