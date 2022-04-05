import 'package:clean_architecture_tdd_solid/infra/cache/local_storage_adapter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorage;
  late String key;
  late String value;
  late String result;

  When mockSaveCall() => when(() => localStorage.setItem(any(), any()));

  When mockDeleteCall() => when(() => localStorage.deleteItem(any()));

  When mockFetchCall() => when(() => localStorage.getItem(any()));

  void mockSave() => mockSaveCall().thenAnswer((_) => Future.value());

  void mockSaveError() => mockSaveCall().thenThrow(Exception());

  void mockDelete() => mockDeleteCall().thenAnswer((_) => Future.value());

  void mockDeleteError() => mockDeleteCall().thenThrow(Exception());

  void mockFetch() => mockFetchCall().thenAnswer((_) => Future.value(result));

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    result = faker.randomGenerator.string(50);

    mockSave();
    mockDelete();
    mockFetch();
  });

  group("save", () {
    test("Deve chamar localStorage com valores corretos", () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test("Deve throw se DeleteItem throws", () async {
      mockDeleteError();

      final Future future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });

    test("Deve throw se SetItem throws", () async {
      mockSaveError();

      final Future future = sut.save(key: key, value: value);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group("delete", () {
    test("Deve chamar localStorage com valores corretos", () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test("Deve throw se DeleteItem throws", () async {
      mockDeleteError();

      final Future future = sut.delete(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });

  group("fetch", () {
    test("Deve chamar localStorage com valores corretos", () async {
      final dynamic data = await sut.fetch(key);

      expect(data, result);
    });

    test("Deve chamar localStorage com valores corretos", () async {
      await sut.fetch(key);

      verify(() => localStorage.getItem(key)).called(1);
    });

    test("Deve throw se GetItem throws", () async {
      mockFetchError();

      final Future future = sut.fetch(key);

      expect(future, throwsA(const TypeMatcher<Exception>()));
    });
  });
}