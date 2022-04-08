import 'package:clean_architecture_tdd_solid/presentation/mixins/navigation_manager.dart';
import 'package:get/get.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/usecases/load_current_account.dart';
import '../../ui/pages/splash/splash_presenter.dart';

class GetxSplashPresenter extends GetxController with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      final AccountEntity? account = await loadCurrentAccount.load();

      navigateTo = account == null ? "/login" : "/surveys";
    } catch (e) {
      navigateTo = "/login";
    }
  }
}