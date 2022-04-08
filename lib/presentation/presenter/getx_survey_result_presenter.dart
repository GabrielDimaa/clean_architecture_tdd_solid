import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/session_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:get/get.dart';
import '../../domain/entities/survey_result_entity.dart';
import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/ui_error.dart';

class GetxSurveyResultPresenter extends GetxController with LoadingManager, SessionManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({required this.loadSurveyResult, required this.surveyId});

  @override
  Future<void> loadData() async {
    try {
      loading = true;

      final SurveyResultEntity surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);

      _surveyResult.value = SurveyResultViewModel(
        surveyId: surveyResult.surveyId,
        question: surveyResult.question,
        answers: surveyResult.answers
            .map((e) => SurveyAnswerViewModel(
                  image: e.image,
                  answer: e.answer,
                  isCurrentAnswer: e.isCurrentAnswer,
                  percent: "${e.percent}%",
                ))
            .toList(),
      );
    } on DomainError catch (error) {
      if (error == DomainError.accessDenied) {
        sessionExpired = true;
      } else {
        _surveyResult.subject.addError(UIError.unexpected.descricao);
      }
    } finally {
      loading = false;
    }
  }

  final Rxn<SurveyResultViewModel> _surveyResult = Rxn<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> save({required String answer}) {
    // TODO: implement save
    throw UnimplementedError();
  }
}
