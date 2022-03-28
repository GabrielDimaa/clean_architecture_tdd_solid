import 'package:clean_architecture_tdd_solid/main/factories/pages/signup/signup_presenter_factory.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';

Widget makeSignUpPage() {
  return SignUpPage(presenter: makeGetxSignUpPresenter());
}
