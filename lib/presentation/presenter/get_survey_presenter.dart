import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/survey_entity.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/load_surveys.dart';
import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/surveys/surveys_presenter.dart';
import '../../ui/pages/surveys/survey_view_model.dart';

class GetxSurveysPresenter extends GetxController implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      _loading.value = true;

      final List<SurveyEntity> surveys = await loadSurveys.load();

      _surveys.value = surveys
          .map((e) => SurveyViewModel(
        id: e.id,
        question: e.question,
        date: DateFormat('dd MMM yyyy').format(e.datetime),
        didAnswer: e.didAnswer,
      ))
          .toList();
    } on DomainError {
      _surveys.subject.addError(UIError.unexpected.descricao);
    } finally {
      _loading.value = false;
    }
  }

  final RxBool _loading = true.obs;
  final Rx<List<SurveyViewModel>> _surveys = Rx<List<SurveyViewModel>>([]);

  @override
  Stream<bool> get loadingStream => _loading.stream;

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  void goToSurveyResult(String surveyId) {
    // TODO: implement goToSurveyResult
  }

  @override
  // TODO: implement navigateToStream
  Stream<String?> get navigateToStream => throw UnimplementedError();

  @override
  // TODO: implement sessionExpiredStream
  Stream<bool> get sessionExpiredStream => throw UnimplementedError();
}