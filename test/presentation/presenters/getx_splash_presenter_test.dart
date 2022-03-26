import 'package:clean_architecture_tdd_solid/domain/entities/account_entity.dart';
import 'package:clean_architecture_tdd_solid/domain/usecases/load_current_account.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_splash_presenter.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;
  late AccountEntity accountEntity;

  When mockLoadAccountCall() => when(() => loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity? account}) => mockLoadAccountCall().thenAnswer((_) => Future.value(account));

  void mockLoadCurrentAccountError() => mockLoadAccountCall().thenThrow(Exception());

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    accountEntity = AccountEntity(faker.guid.guid());

    mockLoadCurrentAccount(account: accountEntity);
  });

  test("Deve chamar LoadCurrentAccount", () async {
    await sut.checkAccount();

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test("Deve ir para Page surveys em caso de sucesso", () async {
    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/surveys")));

    await sut.checkAccount();
  });

  test("Deve ir para Page Login se resultado for null", () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/login")));

    await sut.checkAccount();
  });

  test("Deve ir para Page Login se der erro", () async {
    mockLoadCurrentAccountError();

    sut.navigateToStream.listen(expectAsync1((page) => expect(page, "/login")));

    await sut.checkAccount();
  });
}