import 'package:clean_architecture_tdd_solid/main/factories/pages/login/login_presenter_factory.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/login_page.dart';
import 'package:flutter/material.dart';

Widget makeLoginPage() {
  return LoginPage(presenter: makeLoginPresenter());
}
