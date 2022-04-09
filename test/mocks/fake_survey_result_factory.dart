import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:faker/faker.dart';

abstract class FakeSurveyResultFactory {
  static Map makeCacheJson() =>
      //Optado por salvar no cache tudo em string.
      {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': "true",
            'percent': "40",
          },
          {
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': "false",
            'percent': "60",
          },
        ],
      };

  static Map makeInvalidCacheJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': "invalid bool",
            'percent': "invalid int",
          }
        ],
      };

  static Map makeIncompleteCacheJson() => {'surveyId': faker.guid.guid()};

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.randomGenerator.string(10),
            isCurrentAnswer: true,
            percent: 40,
          ),
          SurveyAnswerEntity(
            answer: faker.randomGenerator.string(10),
            isCurrentAnswer: false,
            percent: 60,
          ),
        ],
      );

  static Map makeApiJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(100),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(100),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  static Map makeInvalidApiJson() => {'invalid_key': 'invalid_value'};
}
