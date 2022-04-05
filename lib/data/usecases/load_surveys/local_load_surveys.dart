import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/load_surveys.dart';
import '../../cache/fetch_cache_storage.dart';
import '../../models/local_survey_model.dart';

class LocalLoadSurveys implements LoadSurveys {
  final CacheStorage cacheStorage;

  LocalLoadSurveys({required this.cacheStorage});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final data = await cacheStorage.fetch("surveys");

      if (data == null || data is List && data.isEmpty) {
        throw Exception();
      }

      return _map(data);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }


  Future<void> validate() async {
    try {
      final data = await cacheStorage.fetch("surveys");

      _map(data);
    } catch (error) {
      await cacheStorage.delete("surveys");
    }
  }

  Future<void> save(List<SurveyEntity> surveys) async {
    try {
      await cacheStorage.save(key: "surveys", value: _mapToJson(surveys));
    } catch (e) {
      throw DomainError.unexpected;
    }
  }

  List<SurveyEntity> _map(dynamic list) => list.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();

  List<Map<String, String>> _mapToJson(List<SurveyEntity> list) => list.map((entity) => LocalSurveyModel.fromEntity(entity).toJson()).toList();
}