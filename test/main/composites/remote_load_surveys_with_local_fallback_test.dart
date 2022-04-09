import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/local_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_surveys/remote_load_surveys.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/survey_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:clean_architecture_tdd_solid/main/composites/remote_load_surveys_with_local_fallback.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/fake_surveys_factory.dart';

class RemoteLoadSurveysSpy extends Mock implements RemoteLoadSurveys {}

class LocalLoadSurveysSpy extends Mock implements LocalLoadSurveys {}

void main() {
  late RemoteLoadSurveysWithLocalFallback sut;
  late RemoteLoadSurveysSpy remote;
  late LocalLoadSurveysSpy local;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  When mockRemoteLoadCall() => when(() => remote.load());

  When mockLocalSaveCall() => when(() => local.save(remoteSurveys));

  When mockLocalLoadCall() => when(() => local.load());

  When mockLocalValidateCall() => when(() => local.validate());

  void mockRemoteLoad() => mockRemoteLoadCall().thenAnswer((_) => Future.value(remoteSurveys));

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  void mockLocalSave() => mockLocalSaveCall().thenAnswer((_) => Future.value());

  void mockLocalLoad() => mockLocalLoadCall().thenAnswer((_) => Future.value(localSurveys));

  void mockLocalLoadError(DomainError error) => mockLocalLoadCall().thenThrow(error);

  void mockLocalValidate() => mockLocalValidateCall().thenAnswer((_) => Future.value());

  List<SurveyEntity> mockSurveys() => FakeSurveysFactory.makeEntities();

  setUp(() {
    remote = RemoteLoadSurveysSpy();
    local = LocalLoadSurveysSpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);

    remoteSurveys = mockSurveys();
    localSurveys = mockSurveys();
    mockRemoteLoad();
    mockLocalLoad();
    mockLocalSave();
    mockLocalValidate();
  });

  test("Deve chamar remote load", () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test("Deve chamar local save com valores corretos", () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test("Deve retornar remote data", () async {
    final List<SurveyEntity> surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test("Deve rethrow se remoteLoad throws AccessDeniedError", () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final Future future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test("Deve chamar localFetch em remote error", () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test("Deve chamar localFetch em remote error", () async {
    mockRemoteLoadError(DomainError.unexpected);

    final List<SurveyEntity> surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test("Deve throw UnexpectedError se remote e local throws", () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError(DomainError.unexpected);

    final Future future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}