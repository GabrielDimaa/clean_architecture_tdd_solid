import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/local_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_survey_result/remote_load_survey_result.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_result_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/main/composites/remote_load_survey_result_with_local_fallback.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_survey_result_factory.dart';

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {}

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

void main() {
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late LocalLoadSurveyResultSpy local;
  late String surveyId;
  late SurveyResultEntity remoteSurveyResult;
  late SurveyResultEntity localSurveyResult;

  void mockRemoteSurveyResult() => remoteSurveyResult = FakeSurveyResultFactory.makeEntity();

  void mockLocalSurveyResult() => localSurveyResult = FakeSurveyResultFactory.makeEntity();

  When mockRemoteLoadBySurveyCall() => when(() => remote.loadBySurvey(surveyId: any(named: 'surveyId')));

  When mockLocalLoadBySurveyCall() => when(() => local.loadBySurvey(surveyId: any(named: 'surveyId')));

  When mockLocalValidateCall() => when(() => local.validate(any()));

  When mockLocalSaveCall() => when(() => local.save(remoteSurveyResult));

  void mockRemoteLoadBySurvey() => mockRemoteLoadBySurveyCall().thenAnswer((_) => Future.value(remoteSurveyResult));

  void mockRemoteLoadBySurveyError(DomainError error) => mockRemoteLoadBySurveyCall().thenThrow(error);

  void mockLocalLoadBySurvey() => mockLocalLoadBySurveyCall().thenAnswer((_) => Future.value(localSurveyResult));

  void mockLoadLoadBySurveyError() => mockLocalLoadBySurveyCall().thenThrow(DomainError.unexpected);

  void mockLocalValidate() => mockLocalValidateCall().thenAnswer((_) => Future.value());

  void mockLocalSave() => mockLocalSaveCall().thenAnswer((_) => Future.value());

  setUp(() {
    remote = RemoteLoadSurveyResultSpy();
    local = LocalLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    surveyId = faker.guid.guid();

    mockRemoteSurveyResult();
    mockLocalSurveyResult();

    mockRemoteLoadBySurvey();
    mockLocalLoadBySurvey();
    mockLocalValidate();
    mockLocalSave();
  });

  test("Deve chamar remote LoadBySurvey", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Deve chamar local save com remote data", () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(remoteSurveyResult)).called(1);
  });

  test("Deve retornar remote data", () async {
    final SurveyResultEntity response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteSurveyResult);
  });

  test("Deve rethrow se remote LoadBySurvey throws AccessDeniedError", () {
    mockRemoteLoadBySurveyError(DomainError.accessDenied);

    final Future future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test("Deve chamar local LoadBySurvey quando remote error", () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test("Deve retornar local data", () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    final SurveyResultEntity response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localSurveyResult);
  });

  test("Deve throw UnexpectedError se local load falhar", () {
    mockRemoteLoadBySurveyError(DomainError.unexpected);
    mockLoadLoadBySurveyError();

    final Future response = sut.loadBySurvey(surveyId: surveyId);

    expect(response, throwsA(DomainError.unexpected));
  });
}
