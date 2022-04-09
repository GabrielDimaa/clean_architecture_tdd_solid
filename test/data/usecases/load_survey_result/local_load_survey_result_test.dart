import 'package:clean_architecture_tdd_solid/data/cache/fetch_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/local_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group("loadBySurvey", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late String surveyId;
    Map? data;

    Map mockValidData() =>
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

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(Map? map) {
      data = map;
      mockFetchCall().thenAnswer((_) => Future.value(data));
    }

    void mockFetchError() {
      mockFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();

      mockFetch(mockValidData());
    });

    test("Deve chamar FetchCacheStorage com valores corretos", () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch("surveys")).called(1);
    });

    test("Deve retornar surveyResult quando sucesso", () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data!['surveyId'],
          question: data!['question'],
          answers: [
            SurveyAnswerEntity(
              image: data!['answers'][0]['image'],
              answer: data!['answers'][0]['image'],
              isCurrentAnswer: true,
              percent: 40,
            ),
            SurveyAnswerEntity(
              answer: data!['answers'][1]['answer'],
              isCurrentAnswer: false,
              percent: 60,
            ),
          ],
        ),
      );
    });

    test("Deve throw UnexpectedError se cache for vazio", () async {
      mockFetch({});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se cache for invalid", () async {
      mockFetch({
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
      });

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se cache é incompleto", () async {
      mockFetch({'surveyId': faker.guid.guid()});

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se cache error", () async {
      mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group("validate", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late String surveyId;
    Map? data;

    Map mockValidData() => {
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

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    When mockDeleteCall() => when(() => cacheStorage.delete(any()));

    void mockFetch(Map map) {
      data = map;
      mockFetchCall().thenAnswer((_) => Future.value(data));
    }

    void mockDelete() {
      mockDeleteCall().thenAnswer((_) => Future.value());
    }

    void mockFetchError() {
      mockFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();

      mockFetch(mockValidData());
      mockDelete();
    });

    test("Deve chamar CacheStorage com valores corretos", () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch("survey_result/$surveyId")).called(1);
    });

    test("Deve remover cache se for inválido", () async {
      mockFetch({
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
      });

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete("surveys")).called(1);
    });

    test("Deve remover cache se for incompleto", () async {
      mockFetch({'surveyId': faker.guid.guid()});

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete("surveys")).called(1);
    });

    test("Deve remover cache se Fetch error", () async {
      mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete("surveys")).called(1);
    });
  });

  group("save", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveyResult sut;
    late SurveyResultEntity surveyResult;
    late String surveyId;

    SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
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

    When mockSaveCall() => when(() => cacheStorage.save(key: any(named: "key"), value: any(named: "value")));

    void mockSave() {
      mockSaveCall().thenAnswer((_) => Future.value());
    }

    void mockSaveError() {
      mockSaveCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
      surveyId = faker.guid.guid();

      surveyResult = mockSurveyResult();
      mockSave();
    });

    test("Deve chamar CacheStorage com valores corretos", () async {
      final map = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'isCurrentAnswer': "true",
            'percent': "40"
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'isCurrentAnswer': "false",
            'percent': "60"
          },
        ],
      };

      await sut.save(surveyResult);

      verify(() => cacheStorage.save(key: "survey_result/${surveyResult.surveyId}", value: map)).called(1);
    });

    test("Deve throw UnexpectedError se save throws", () async {
      mockSaveError();

      final Future future = sut.save(surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
