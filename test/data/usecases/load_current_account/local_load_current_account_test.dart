import 'package:clean_architecture_tdd_solid/data/cache/fetch_secure_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/load_current_account/local_fetch_current_account.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late LocalLoadCurrentAccount sut;
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late String token;

  When mockFetchSecureCall() => when(() => fetchSecureCacheStorage.fetch(any()));

  void mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) => Future.value(token));

  void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage);
    token = faker.guid.guid();

    mockFetchSecure();
  });

  test("Deve chamar FetchSecureCacheStorage com valor correto", () async {
    await sut.load();

    verify(() => fetchSecureCacheStorage.fetch("token"));
  });

  test("Deve retornar AccountEntity", () async {
    final AccountEntity? account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test("Deve throw UnexpectedError se FetchSecureCacheStorage throws", () async {
    mockFetchSecureError();

    final Future account = sut.load();

    expect(account, throwsA(DomainError.unexpected));
  });
}