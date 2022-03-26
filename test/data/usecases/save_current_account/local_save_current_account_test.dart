import 'package:clean_architecture_tdd_solid/data/cache/save_secure_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/data/usecases/save_current_account/local_save_current_account.dart';
import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/helpers/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {}

void main() {
  late LocalSaveCurrentAccount sut;
  late SaveSecureCacheStorageSpy saveSecureCacheStorage;
  late AccountEntity account;

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
    account = AccountEntity(faker.guid.guid());
  });

  test("Deve chamar SaveSecureCacheStorage com valores corretos", () async {
    when(() => saveSecureCacheStorage.saveSecure(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) => Future.value());

    await sut.save(account);

    verify(() => saveSecureCacheStorage.saveSecure(key: "token", value: account.token));
  });

  test("Deve throw UnexpectedError se SaveSecureCacheStorage throws", () async {
    when(() => saveSecureCacheStorage.saveSecure(key: any(named: 'key'), value: any(named: 'value'))).thenThrow(Exception());

    final Future future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}