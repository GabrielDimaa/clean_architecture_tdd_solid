import 'package:clean_architecture_tdd_solid/infra/cache/secure_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  late SecureStorageAdapter sut;
  late FlutterSecureStorageSpy secureStorage;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);

    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group("save", () {
    When mockSaveSecureCall() => when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveSecure() => mockSaveSecureCall().thenAnswer((_) => Future.value());

    void mockSaveSecureError() => mockSaveSecureCall().thenThrow(Exception());

    setUp(() => mockSaveSecure());

    test("Deve chamar saveSecure com valores corretos", () async {
      await sut.saveSecure(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test("Deve throw se saveSecure throws", () async {
      mockSaveSecureError();

      final Future future = sut.saveSecure(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group("fetch", () {
    When mockFetchSecureCall() => when(() => secureStorage.read(key: any(named: 'key')));

    void mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) => Future.value(value));

    void mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

    setUp(() => mockFetchSecure());

    test("Deve chamar fetchSecure com valor correto", () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test("Deve retornar valor correto em caso de sucesso", () async {
      final String? fetchValue = await sut.fetch(key);

      expect(fetchValue, value);
    });

    test("Deve throw se fetchSecure throws", () async {
      mockFetchSecureError();

      final Future future = sut.fetch(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group("delete", () {
    When mockDeleteSecureCall() => when(() => secureStorage.delete(key: any(named: 'key')));

    void mockDeleteSecure() => mockDeleteSecureCall().thenAnswer((_) => Future.value(value));

    void mockDeleteError() => mockDeleteSecureCall().thenThrow(Exception());

    setUp(() => mockDeleteSecure());

    test("Deve chamar delete com chave correta", () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test("Deve throw se delete throws", () async {
      mockDeleteError();

      final Future future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}