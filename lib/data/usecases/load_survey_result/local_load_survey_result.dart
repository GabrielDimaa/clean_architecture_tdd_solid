import 'package:clean_architecture_tdd_solid/data/models/local_survey_result_model.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';

import '../../../domain/helpers/domain_error.dart';
import '../../cache/fetch_cache_storage.dart';

class LocalLoadSurveyResult implements LoadSurveyResult {
  final CacheStorage cacheStorage;

  LocalLoadSurveyResult({required this.cacheStorage});

  @override
  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final data = await cacheStorage.fetch("surveys");

      if (data?.isEmpty ?? true) {
        throw Exception();
      }

      return LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      throw DomainError.unexpected;
    }
  }

  Future<void> validate(String surveyId) async {
    try {
      final data = await cacheStorage.fetch('survey_result/$surveyId');
      LocalSurveyResultModel.fromJson(data).toEntity();
    } catch (error) {
      await cacheStorage.delete("surveys");
    }
  }

  Future<void> save(SurveyResultEntity surveyResult) async {
    try {
      final json = LocalSurveyResultModel.fromEntity(surveyResult).toJson();
      print(json);
      await cacheStorage.save(key: 'survey_result/${surveyResult.surveyId}', value: json);
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}