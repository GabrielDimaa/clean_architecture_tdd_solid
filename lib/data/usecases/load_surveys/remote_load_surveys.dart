import '../../../domain/entities/survey_entity.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/usecases/load_surveys.dart';
import '../../http/http_client.dart';
import '../../http/http_error.dart';
import '../../models/remote_survey_model.dart';

class RemoteLoadSurveys implements LoadSurveys {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSurveys({required this.url, required this.httpClient});

  @override
  Future<List<SurveyEntity>> load() async {
    try {
      final httpResponse = await httpClient.request(url: url, method: "get");

      return httpResponse.map<SurveyEntity>((json) => RemoteSurveyModel.fromJson(json).toEntity()).toList();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }
  }

  @override
  Future<void> save(List<SurveyEntity> surveys) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<void> validate() {
    // TODO: implement validate
    throw UnimplementedError();
  }
}