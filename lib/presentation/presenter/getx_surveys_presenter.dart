import 'package:clean_architecture_tdd_solid/presentation/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/session_manager.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/survey_entity.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/load_surveys.dart';
import '../../ui/helpers/errors/ui_error.dart';
import '../../ui/pages/surveys/surveys_presenter.dart';
import '../../ui/pages/surveys/survey_view_model.dart';
import '../mixins/navigation_manager.dart';

class GetxSurveysPresenter extends GetxController with SessionManager, LoadingManager, NavigationManager implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({required this.loadSurveys});

  @override
  Future<void> loadData() async {
    try {
      loading = true;

      final List<SurveyEntity> surveys = await loadSurveys.load();

      _surveys.value = surveys
          .map((e) => SurveyViewModel(
        id: e.id,
        question: e.question,
        date: DateFormat('dd MMM yyyy').format(e.datetime),
        didAnswer: e.didAnswer,
      ))
          .toList();
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        sessionExpired = true;
      } else {
        _surveys.subject.addError(UIError.unexpected.descricao);
      }
    } finally {
      loading = false;
    }
  }

  final Rx<List<SurveyViewModel>> _surveys = Rx<List<SurveyViewModel>>([]);

  @override
  Stream<List<SurveyViewModel>> get surveysStream => _surveys.stream;

  @override
  void goToSurveyResult(String surveyId) => navigateTo = "/survey_result/$surveyId";
}