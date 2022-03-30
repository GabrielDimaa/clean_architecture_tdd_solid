import 'package:equatable/equatable.dart';

class SurveyEntity extends Equatable {
  final String id;
  final String question;
  final DateTime datetime;
  final bool didAnswer;

  const SurveyEntity({
    required this.id,
    required this.question,
    required this.datetime,
    required this.didAnswer,
  });

  @override
  List<Object?> get props => ['id', 'question', 'dateTime', 'didAnswer'];
}
