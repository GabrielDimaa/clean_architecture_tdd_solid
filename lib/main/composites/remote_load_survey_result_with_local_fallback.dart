import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';

import '../../data/usecases/load_survey_result/local_load_survey_result.dart';
import '../../data/usecases/load_survey_result/remote_load_survey_result.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/load_survey_result.dart';

class RemoteLoadSurveyResultWithLocalFallback implements LoadSurveyResult {
  final RemoteLoadSurveyResult remote;
  final LocalLoadSurveyResult local;

  RemoteLoadSurveyResultWithLocalFallback({required this.remote, required this.local});

  @override
  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      SurveyResultEntity surveyResult = await remote.loadBySurvey(surveyId: surveyId);
      await local.save(surveyResult);

      return surveyResult;
    } catch (error) {
      if (error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate(surveyId);
      return await local.loadBySurvey(surveyId: surveyId);
    }
  }
}