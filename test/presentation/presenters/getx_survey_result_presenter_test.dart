import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/save_survey_result.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_survey_result_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SaveSurveyResultSpy saveSurveyResult;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            image: faker.internet.httpUrl(),
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: faker.randomGenerator.boolean(),
            percent: faker.randomGenerator.integer(100),
          ),
        ],
      );

  When mockLoadSurveyResultCall() => when(() => loadSurveyResult.loadBySurvey(surveyId: any(named: 'surveyId')));

  When mockSaveSurveyResultCall() => when(() => saveSurveyResult.save(answer: any(named: 'answer')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) => Future.value(data));
  }

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) => Future.value(data));
  }

  void mockLoadSurveyResultError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
  }

  void mockSaveSurveyResultError() {
    mockSaveSurveyResultCall().thenThrow(DomainError.unexpected);
  }

  void mockAccessDeniedError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);
    mockSaveSurveyResultCall().thenThrow(DomainError.accessDenied);
  }

  SurveyResultViewModel mapToViewModel(SurveyResultEntity entity) {
    return SurveyResultViewModel(
      surveyId: entity.surveyId,
      question: entity.question,
      answers: [
        SurveyAnswerViewModel(
          image: entity.answers[0].image,
          answer: entity.answers[0].answer,
          isCurrentAnswer: entity.answers[0].isCurrentAnswer,
          percent: "${entity.answers[0].percent}%",
        ),
        SurveyAnswerViewModel(
          answer: entity.answers[1].answer,
          isCurrentAnswer: entity.answers[1].isCurrentAnswer,
          percent: "${entity.answers[1].percent}%",
        ),
      ],
    );
  }

  setUp(() {
    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId,
    );

    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group("loadData", () {
    test("Deve chamar LoadSurveyResult on loadData", () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test("Deve emitir evento correto em caso de sucesso", () async {
      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result, mapToViewModel(loadResult))));

      await sut.loadData();
    });

    test("Deve emitir evento correto se falhar", () async {
      mockLoadSurveyResultError();

      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((err) => expect(err, UIError.unexpected.descricao)));

      await sut.loadData();
    });

    test("Deve emitir evento correto se perder token de acesso", () async {
      mockAccessDeniedError();

      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      expectLater(sut.sessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group("save", () {
    test("Deve chamar SAveSurveyResult on save", () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test("Deve emitir evento correto em caso de sucesso", () async {
      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      expectLater(sut.surveyResultStream, emitsInOrder([mapToViewModel(loadResult), mapToViewModel(saveResult)]));

      await sut.loadData();
      await sut.save(answer: answer);
    });

    test("Deve emitir evento correto se falhar", () async {
      mockSaveSurveyResultError();

      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((err) => expect(err, UIError.unexpected.descricao)));

      await sut.save(answer: answer);
    });

    test("Deve emitir evento correto se perder token de acesso", () async {
      mockAccessDeniedError();

      expectLater(sut.loadingStream, emitsInOrder([true, false]));
      expectLater(sut.sessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}
