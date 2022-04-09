import 'package:clean_architecture_tdd_solid/data/cache/fetch_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fake_surveys_factory.dart';

class CacheStorageSpy extends Mock implements CacheStorage {}

void main() {
  group("load", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    List<Map>? data;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    void mockFetch(List<Map>? list) {
      data = list;
      mockFetchCall().thenAnswer((_) => Future.value(data));
    }

    void mockFetchError() {
      mockFetchCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      mockFetch(FakeSurveysFactory.makeCacheJson());
    });

    test("Deve chamar FetchCacheStorage com valores corretos", () async {
      await sut.load();

      verify(() => cacheStorage.fetch("surveys")).called(1);
    });

    test("Deve retornar a lista de surveys quando sucesso", () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(id: data![0]['id'], question: data![0]['question'], dateTime: DateTime.utc(2020, 7, 20), didAnswer: false),
        SurveyEntity(id: data![1]['id'], question: data![1]['question'], dateTime: DateTime.utc(2019, 2, 2), didAnswer: true),
      ]);
    });

    test("Deve throw UnexpectedError se cache for vazio", () async {
      mockFetch([]);

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se cache for invalid", () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se cache é incompleto", () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test("Deve throw UnexpectedError se Fetch error", () async {
      mockFetchError();

      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group("validate", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    List<Map>? data;

    When mockFetchCall() => when(() => cacheStorage.fetch(any()));

    When mockDeleteCall() => when(() => cacheStorage.delete(any()));

    void mockFetch(List<Map>? list) {
      data = list;
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
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      mockFetch(FakeSurveysFactory.makeCacheJson());
      mockDelete();
    });

    test("Deve chamar CacheStorage com valores corretos", () async {
      await sut.validate();

      verify(() => cacheStorage.fetch("surveys")).called(1);
    });

    test("Deve remover cache se for inválido", () async {
      mockFetch(FakeSurveysFactory.makeInvalidCacheJson());

      await sut.validate();

      verify(() => cacheStorage.delete("surveys")).called(1);
    });

    test("Deve remover cache se for incompleto", () async {
      mockFetch(FakeSurveysFactory.makeIncompleteCacheJson());

      await sut.validate();

      verify(() => cacheStorage.delete("surveys")).called(1);
    });

    test("Deve remover cache se Fetch error", () async {
      mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete("surveys")).called(1);
    });
  });

  group("save", () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    late List<SurveyEntity> surveys;

    When mockSaveCall() => when(() => cacheStorage.save(key: any(named: "key"), value: any(named: "value")));

    void mockSave() {
      mockSaveCall().thenAnswer((_) => Future.value());
    }

    void mockSaveError() {
      mockSaveCall().thenThrow(Exception());
    }

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);

      surveys = FakeSurveysFactory.makeEntities();
      mockSave();
    });

    test("Deve chamar CacheStorage com valores corretos", () async {
      final list = [
        {
          'id': surveys[0].id,
          'question': surveys[0].question,
          'date': "2020-02-02T00:00:00.000Z",
          'didAnswer': "true",
        },
        {
          'id': surveys[1].id,
          'question': surveys[1].question,
          'date': "2018-12-20T00:00:00.000Z",
          'didAnswer': "false",
        }
      ];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: "surveys", value: list)).called(1);
    });

    test("Deve throw UnexpectedError se save throws", () async {
      mockSaveError();

      final Future future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
