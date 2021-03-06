import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';

class RemoteSurveyAnswerModel {
  final String? image;
  final String answer;
  final bool isCurrentAccountAnswer;
  final int percent;

  RemoteSurveyAnswerModel({
    this.image,
    required this.answer,
    required this.isCurrentAccountAnswer,
    required this.percent,
  });

  factory RemoteSurveyAnswerModel.fromJson(Map json) {
    if (!json.keys.toSet().containsAll(['answer', 'isCurrentAccountAnswer', 'percent'])) {
      throw HttpError.invalidData;
    }

    return RemoteSurveyAnswerModel(
      image: json['image'],
      answer: json['answer'],
      isCurrentAccountAnswer: json['isCurrentAccountAnswer'],
      percent: json['percent'],
    );
  }

  SurveyAnswerEntity toEntity() => SurveyAnswerEntity(
        image: image,
        answer: answer,
        isCurrentAnswer: isCurrentAccountAnswer,
        percent: percent,
      );
}
