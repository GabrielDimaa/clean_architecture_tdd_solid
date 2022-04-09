import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_survey_result.dart';
import 'package:clean_architecture_tdd_solid/presentation/helpers/survey_result_entity_extensions.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/navigation_manager.dart';
import 'package:clean_architecture_tdd_solid/presentation/mixins/session_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:get/get.dart';

import '../../domain/entities/survey_result_entity.dart';
import '../../domain/helpers/domain_error.dart';
import '../../ui/helpers/errors/ui_error.dart';

class GetxSurveyResultPresenter extends GetxController with SessionManager, LoadingManager, NavigationManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  GetxSurveyResultPresenter({required this.loadSurveyResult, required this.saveSurveyResult, required this.surveyId});

  @override
  Future<void> loadData() async => await showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));

  final Rxn<SurveyResultViewModel> _surveyResult = Rxn<SurveyResultViewModel>();

  @override
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  @override
  Future<void> save({required String answer}) async => showResultOnAction(() => saveSurveyResult.save(answer: answer));

  Future<void> showResultOnAction(Future<SurveyResultEntity> Function() action) async {
    try {
      loading = true;

      final SurveyResultEntity surveyResult = await action();

      _surveyResult.value = surveyResult.toViewModel();
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
}
