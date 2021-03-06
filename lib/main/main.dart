import 'package:clean_architecture_tdd_solid/ui/components/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'factories/pages/login/login_page_factory.dart';
import 'factories/pages/signup/signup_page_factory.dart';
import 'factories/pages/splash/splash_page_factory.dart';
import 'factories/pages/survey_result/survey_result_page_factory.dart';
import 'factories/pages/surveys/surveys_page_factory.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final RouteObserver<Route> routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "4Dev",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      navigatorObservers: [routeObserver],
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/", page: makeSplashPage),
        GetPage(name: "/login", page: makeLoginPage),
        GetPage(name: "/signup", page: makeSignUpPage),
        GetPage(name: "/surveys", page: makeSurveysPage),
        GetPage(name: "/surveys_result/:survey_id", page: makeSurveyResultPage),
      ],
    );
  }
}