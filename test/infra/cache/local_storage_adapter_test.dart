import 'package:clean_architecture_tdd_solid/data/cache/save_secure_cache_storage.dart';
import 'package:clean_architecture_tdd_solid/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late LocalStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  test("Deve chamar saveSecure com valores corretos", () async {
    when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) => Future.value());

    await sut.saveSecure(key: key, value: value);

    verify(() => secureStorage.write(key: key, value: value));
  });

  test("Deve throw se saveSecure throws", () async {
    when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value'))).thenThrow(Exception());

    final Future future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(const TypeMatcher<Exception>()));
  });
}