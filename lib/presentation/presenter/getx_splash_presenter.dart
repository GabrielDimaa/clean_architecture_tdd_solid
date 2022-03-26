import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/load_current_account.dart';
import '../../ui/pages/splash/splash_presenter.dart';

class GetxSplashPresenter implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  final RxnString _navigateTo = RxnString();

  @override
  Future<void> checkAccount() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final AccountEntity? account = await loadCurrentAccount.load();

      _navigateTo.value = account == null ? "/login" : "/surveys";
    } catch (e) {
      _navigateTo.value = "/login";
    }
  }

  @override
  Stream<String?> get navigateToStream => _navigateTo.stream;
}