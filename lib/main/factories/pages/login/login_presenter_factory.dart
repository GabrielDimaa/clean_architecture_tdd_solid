import 'package:clean_architecture_tdd_solid/main/factories/pages/login/login_validation_factory.dart';
import 'package:clean_architecture_tdd_solid/main/factories/usecases/authentication_factory.dart';
import 'package:clean_architecture_tdd_solid/presentation/presenter/stream_login_presenter.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_presenter.dart';

LoginPresenter makeStreamLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}

LoginPresenter makeGetxLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}