import 'package:clean_architecture_tdd_solid/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/usecases/save_current_account_factory.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/getx_signup_presenter.dart';
import '../../usecases/add_account_factory.dart';

GetxSignUpPresenter makeGetxSignUpPresenter() {
  return GetxSignUpPresenter(
    addAccount: makeRemoteAddAccount(),
    validation: makeLoginValidation(),
    saveCurrentAccount: makeSaveCurrentAccount(),
  );
}
