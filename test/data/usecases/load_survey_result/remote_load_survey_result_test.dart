import 'package:clean_architecture_tdd_solid/data/http/http.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/remote_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/fake_survey_result_factory.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late Map surveyResult;

  When mockRequest() => when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);

    mockHttpData(FakeSurveyResultFactory.makeApiJson());
  });

  test("Deve chamar HttpClient com valores corretos", () async {
    await sut.loadBySurvey(surveyId: '');

    verify(() => httpClient.request(url: url, method: "get"));
  });

  test("Deve retornar surveys se status 200", () async {
    final surveys = await sut.loadBySurvey(surveyId: '');

    expect(
        surveys,
        SurveyResultEntity(
          surveyId: surveyResult['surveyId'],
          question: surveyResult['question'],
          answers: [
            SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent'],
            ),
            SurveyAnswerEntity(
              image: surveyResult['answers'][1]['image'],
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent'],
            ),
          ],
        ));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 200 com dados inválidos", () {
    mockHttpData(FakeSurveyResultFactory.makeInvalidApiJson());

    final future = sut.loadBySurvey(surveyId: '');

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: '');

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 500", () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: '');

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw accessDenied se HttpClient retornar 403", () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: '');

    expect(future, throwsA(DomainError.accessDenied));
  });
}
