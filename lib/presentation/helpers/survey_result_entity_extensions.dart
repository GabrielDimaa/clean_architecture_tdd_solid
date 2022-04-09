import '../../domain/entities/survey_result_entity.dart';
import '../../domain/entities/surveys_answer_entity.dart';
import '../../ui/pages/survey_result/survey_answer_viewmodel.dart';
import '../../ui/pages/survey_result/survey_result_viewmodel.dart';

extension SurveyResultEntityExtensions on SurveyResultEntity {
  SurveyResultViewModel toViewModel() => SurveyResultViewModel(
    surveyId: surveyId,
    question: question,
    answers: answers.map<SurveyAnswerViewModel>((e) => e.toViewModel()).toList(),
  );
}

extension SurveyAnswerEntityExtensions on SurveyAnswerEntity {
  SurveyAnswerViewModel toViewModel() => SurveyAnswerViewModel(
    image: image,
    answer: answer,
    isCurrentAnswer: isCurrentAnswer,
    percent: "$percent%",
  );
}