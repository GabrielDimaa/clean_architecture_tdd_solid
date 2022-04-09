import 'package:clean_architecture_tdd_solid/data/http/http_client.dart';
import 'package:clean_architecture_tdd_solid/data/http/http_error.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/save_survey_result/remote_save_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/surveys_answer_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteSaveSurveyResult sut;
  late HttpClientSpy httpClient;
  late String url;
  late String answer;
  late Map surveyResult;

  Map mockValidData() =>
      {
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
          }
        ],
        'date': faker.date.dateTime().toIso8601String(),
      };

  When mockRequest() => when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method'), body: any(named: 'body')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  setUp(() {
    url = faker.internet.httpUrl();
    answer = faker.lorem.sentence();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);

    mockHttpData(mockValidData());
  });

  test("Deve chamar HttpClient com valores corretos", () async {
    await sut.save(answer: answer);

    verify(() => httpClient.request(url: url, method: 'put', body: {'answer': answer})).called(1);
  });

  test("Deve retornar surveys se status 200", () async {
    final SurveyResultEntity result = await sut.save(answer: answer);

    expect(
        result,
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

  test("Deve throw UnexpectedError se HttpClient retornar 200 com dados inválidos", () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });


  test("Deve throw UnexpectedError se HttpClient retornar 404", () async {
    mockHttpError(HttpError.notFound);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw UnexpectedError se HttpClient retornar 500", () async {
    mockHttpError(HttpError.serverError);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.unexpected));
  });

  test("Deve throw accessDenied se HttpClient retornar 403", () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.save(answer: answer);

    expect(future, throwsA(DomainError.accessDenied));
  });
}