import 'package:clean_architecture_tdd_solid/ui/components/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'factories/pages/login/login_page_factory.dart';
import 'factories/pages/signup/signup_page_factory.dart';
import 'factories/pages/splash/splash_page_factory.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "4Dev",
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      initialRoute: "/login",
      getPages: [
        GetPage(name: "/", page: makeSplashPage),
        GetPage(name: "/login", page: makeLoginPage),
        GetPage(name: "/signup", page: makeSignUpPage),
        GetPage(name: "/surveys", page: () => const Scaffold(body: Text("Enquetes"))),
      ],
    );
  }
}