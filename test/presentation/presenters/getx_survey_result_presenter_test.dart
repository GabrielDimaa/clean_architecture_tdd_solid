import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_survey_result_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_answer_viewmodel.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/survey_result/survey_result_viewmodel.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  late GetxSurveyResultPresenter sut;
  late LoadSurveyResultSpy loadSurveyResult;
  late SurveyResultEntity surveyResult;
  late String surveyId;

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

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) => Future.value(data));
  }

  void mockLoadSurveyResultError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);
  }

  void mockAccessDeniedError() {
    mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);
  }

  setUp(() {
    loadSurveyResult = LoadSurveyResultSpy();
    surveyId = faker.guid.guid();
    sut = GetxSurveyResultPresenter(loadSurveyResult: loadSurveyResult, surveyId: surveyId);

    mockLoadSurveyResult(mockValidData());
  });

  test("Deve chamar LoadSurveyResult on loadData", () async {
    await sut.loadData();

    verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Deve emitir evento correto em caso de sucesso", () async {
    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.surveyResultStream.listen(expectAsync1((result) => expect(
        result,
        SurveyResultViewModel(
          surveyId: surveyResult.surveyId,
          question: surveyResult.question,
          answers: [
            SurveyAnswerViewModel(
              image: surveyResult.answers[0].image,
              answer: surveyResult.answers[0].answer,
              isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
              percent: "${surveyResult.answers[0].percent}%",
            ),
            SurveyAnswerViewModel(
              answer: surveyResult.answers[1].answer,
              isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
              percent: "${surveyResult.answers[1].percent}%",
            ),
          ],
        ))));

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
}
