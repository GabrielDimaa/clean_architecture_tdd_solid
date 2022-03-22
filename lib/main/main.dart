import 'package:clean_architecture_tdd_solid/ui/components/app_theme.dart';
import 'package:flutter/material.dart';
import '../ui/pages/login/login_page.dart';
import 'package:get/route_manager.dart';

import 'factories/pages/login/login_page_factory.dart';

void main() {
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
        GetPage(name: "/login", page: makeLoginPage),
      ],
    );
  }
}