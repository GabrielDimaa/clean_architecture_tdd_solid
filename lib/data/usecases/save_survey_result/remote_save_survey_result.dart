import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_survey_result.dart';

import '../../models/remote_survey_result_model.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({required this.url, required this.httpClient});

  @override
  Future<SurveyResultEntity> save({required String answer}) async {
    try {
      final dynamic json = await httpClient.request(url: url, method: "put", body: {'answer': answer});

      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }
}