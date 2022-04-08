import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:equatable/equatable.dart';

class SurveyResultEntity extends Equatable {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  const SurveyResultEntity({
    required this.surveyId,
    required this.question,
    required this.answers,
  });

  @override
  List<Object?> get props => ['surveyId', 'question', 'answers'];
}
