import 'package:clean_architecture_tdd_solid/data/models/remote_survey_result_model.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';

import '../../../domain/helpers/domain_error.dart';
import '../../http/http_client.dart';
import '../../http/http_error.dart';

class RemoteLoadSurveyResult implements LoadSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveyResult({required this.url, required this.httpClient});

  @override
  Future<SurveyResultEntity> loadBySurvey({required String surveyId}) async {
    try {
      final httpResponse = await httpClient.request(url: url, method: "get");

      return RemoteSurveyResultModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}