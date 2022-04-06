import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:equatable/equatable.dart';

class SurveyResultViewModel extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;

  @override
  List get props => [surveyId, question, answers];

  const SurveyResultViewModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });
}