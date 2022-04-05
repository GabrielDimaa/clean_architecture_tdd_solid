import '../../data/usecases/load_surveys/local_load_surveys.dart';
import '../../data/usecases/load_surveys/remote_load_surveys.dart';
import '../../domain/entities/survey_entity.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/load_surveys.dart';

class RemoteLoadSurveysWithLocalFallback implements LoadSurveys {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveys local;

  RemoteLoadSurveysWithLocalFallback({required this.remote, required this.local});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final List<SurveyEntity> surveys = await remote.load();
      await local.save(surveys);

      return surveys;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate();
      return await local.load();
    }
  }
}