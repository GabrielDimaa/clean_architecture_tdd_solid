import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';
import 'package:faker/faker.dart';

abstract class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
        //Optado por salvar no cache tudo em string.
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "2020-07-20T00:00:00Z",
          'didAnswer': 'false',
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "2019-02-02T00:00:00Z",
          'didAnswer': 'true',
        },
      ];

  static List<Map> makeInvalidCacheJson() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': "invalid date",
          'didAnswer': 'false',
        },
      ];

  static List<Map> makeIncompleteCacheJson() => [
        {'id': faker.guid.guid(), 'didAnswer': 'false'}
      ];

  static List<SurveyEntity> makeEntities() => [
        SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(10), dateTime: DateTime.utc(2020, 2, 2), didAnswer: true),
        SurveyEntity(id: faker.guid.guid(), question: faker.randomGenerator.string(10), dateTime: DateTime.utc(2018, 12, 20), didAnswer: false),
      ];

  static List<Map> makeApiJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String(),
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String(),
    },
  ];

  static List<Map> makeInvalidApiJson() => [
    {'invalid_key': 'invalid_value'}
  ];
}
