import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/data/models/remote_survey_answer_model.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';

import '../../domain/entities/surveys_answer_entity.dart';

class RemoteSurveyResultModel {
  final String surveyId;
  final String question;
  final List<RemoteSurveyAnswerModel> answers;

  RemoteSurveyResultModel({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  factory RemoteSurveyResultModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['surveyId', 'question', 'answers'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyResultModel(
      surveyId: json['surveyId'],
      question: json['question'],
      answers: json['answers'].map<RemoteSurveyAnswerModel>((answerJson) => RemoteSurveyAnswerModel.fromJson(answerJson)).toList(),
    );
  }

  SurveyResultEntity toEntity() => SurveyResultEntity(
        surveyId: surveyId,
        question: question,
        answers: answers.map<SurveyAnswerEntity>((answer) => answer.toEntity()).toList(),
      );
}
