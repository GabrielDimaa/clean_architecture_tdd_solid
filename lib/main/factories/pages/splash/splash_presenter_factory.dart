import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_splash_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/splash/splash_presenter.dart';

import '../../usecases/load_current_account_factory.dart';

SplashPresenter makeGetxSplashPresenter() {
  return GetxSplashPresenter(loadCurrentAccount: makeLocalLoadCurrentAccount());
}
