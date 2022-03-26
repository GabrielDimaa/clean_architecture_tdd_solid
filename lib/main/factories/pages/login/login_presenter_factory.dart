import 'package:clean_architecture_tdd_solid/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/usecases/authentication_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/usecases/save_current_account_factory.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_login_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';

LoginPresenter makeStreamLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}

LoginPresenter makeGetxLoginPresenter() {
  return GetxLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}
