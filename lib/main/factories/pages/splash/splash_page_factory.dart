import 'package:clean_architecture_tdd_solid/main/factories/pages/splash/splash_presenter_factory.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

Widget makeSplashPage() {
  return SplashPage(presenter: makeGetxSplashPresenter());
}
