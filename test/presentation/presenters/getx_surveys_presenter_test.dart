import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_surveys.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_surveys_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/surveys/survey_view_model.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  late GetxSurveysPresenter sut;
  late LoadSurveysSpy loadSurveys;

  List<SurveyEntity> mockValidData() => [
        SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), datetime: DateTime(2020, 2, 2), didAnswer: true),
        SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), datetime: DateTime(2018, 12, 20), didAnswer: false),
      ];

  When mockLoadSurveysCall() => when(() => loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    mockLoadSurveysCall().thenAnswer((_) => Future.value(data));
  }

  void mockLoadSurveysError() {
    mockLoadSurveysCall().thenThrow(DomainError.unexpected);
  }

  void mockAccessDeniedError() {
    mockLoadSurveysCall().thenThrow(DomainError.accessDenied);
  }

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);

    mockLoadSurveys(mockValidData());
  });

  test("Deve chamar LoadSurveys on loadData", () async {
    await sut.loadData();

    verify(() => loadSurveys.load()).called(1);
  });

  test("Deve emitir evento correto em caso de sucesso", () async {
    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
        SurveyViewModel(id: surveys[0].id, question: surveys[0].question, date: '02 Feb 2020', didAnswer: surveys[0].didAnswer),
        SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '20 Dec 2018', didAnswer: surveys[1].didAnswer),
      ])));

    await sut.loadData();
  });

  test("Deve emitir evento correto se falhar", () async {
    mockLoadSurveysError();

    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null, onError: expectAsync1((err) => expect(err, UIError.unexpected.descricao)));

    await sut.loadData();
  });

  test("Deve emitir evento correto se perder token de acesso", () async {
    mockAccessDeniedError();

    expectLater(sut.loadingStream, emitsInOrder([true, false]));
    expectLater(sut.sessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test("Deve ir para SurveyResultPage quando survey click", () async {
    expectLater(sut.navigateToStream, emitsInOrder(["/survey_result/any_route", "/survey_result/any_route"]));

    sut.goToSurveyResult("any_route");
    sut.goToSurveyResult("any_route");
  });
}
