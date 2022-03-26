void main() {}

// import 'dart:async';
//
// import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
// import 'package:clean_architecture_tdd_solid/ui/pages/pages.dart';
// import 'package:faker/faker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:mocktail/mocktail.dart';
//
// class LoginPresenterSpy extends Mock implements LoginPresenter {}
//
// void main() {
//   late LoginPresenter presenter;
//   late StreamController<UIError> emailErrorController;
//   late StreamController<UIError> passwordErrorController;
//   late StreamController<UIError> mainErrorController;
//   late StreamController<bool> formValidController;
//   late StreamController<bool> loadingController;
//   late StreamController<String> navigateToController;
//
//   void initStreams() {
//     emailErrorController = StreamController<UIError>();
//     passwordErrorController = StreamController<UIError>();
//     mainErrorController = StreamController<UIError>();
//     formValidController = StreamController<bool>();
//     loadingController = StreamController<bool>();
//     navigateToController = StreamController<String>();
//   }
//
//   void mockStreams() {
//     when(() => presenter.emailErrorStream).thenAnswer((_) => emailErrorController.stream);
//     when(() => presenter.passwordErrorStream).thenAnswer((_) => passwordErrorController.stream);
//     when(() => presenter.mainErrorStream).thenAnswer((_) => mainErrorController.stream);
//     when(() => presenter.formValidStream).thenAnswer((_) => formValidController.stream);
//     when(() => presenter.loadingStream).thenAnswer((_) => loadingController.stream);
//     when(() => presenter.navigateToStream).thenAnswer((_) => navigateToController.stream);
//   }
//
//   Future<void> loadPage(WidgetTester tester) async {
//     presenter = LoginPresenterSpy();
//
//     initStreams();
//     mockStreams();
//
//     final loginPage = GetMaterialApp(
//       initialRoute: "/login",
//       getPages: [
//         GetPage(name: "/login", page: () => LoginPage(presenter: presenter)),
//         GetPage(name: "/any_route", page: () => const Scaffold(body: Text("fake page"))),
//       ],
//       home: LoginPage(presenter: presenter),
//     );
//
//     await tester.pumpWidget(loginPage);
//   }
//
//   tearDown(() {
//     emailErrorController.close();
//     passwordErrorController.close();
//     mainErrorController.close();
//     formValidController.close();
//     loadingController.close();
//   });
//
//   testWidgets("Deve carregar corretamente o estado inicial", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     final emailTextChildren = find.descendant(of: find.bySemanticsLabel("Email"), matching: find.byType(Text));
//     expect(
//       emailTextChildren,
//       findsOneWidget,
//       reason: "Quando o TextFormField tiver apenas um filho, não terá errors, porque um dos filhos será o labelText",
//     );
//
//     final passwordTextChildren = find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text));
//     expect(
//       passwordTextChildren,
//       findsOneWidget,
//       reason: "Quando o TextFormField tiver apenas um filho, não terá errors, porque um dos filhos será o labelText",
//     );
//
//     final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
//     expect(button.onPressed, null);
//   });
//
//   testWidgets("Deve chamar validate com valores corretos", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     final email = faker.internet.email();
//     await tester.enterText(find.bySemanticsLabel("Email"), email);
//     verify(() => presenter.validateEmail(email));
//
//     final password = faker.internet.password();
//     await tester.enterText(find.bySemanticsLabel("Senha"), password);
//     verify(() => presenter.validatePassword(password));
//   });
//
//   testWidgets("Deve exibir erro se o email for inválido", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     emailErrorController.add(UIError.invalidField);
//     await tester.pump();
//
//     expect(find.text(UIError.invalidField.descricao), findsOneWidget);
//   });
//
//   testWidgets("Deve exibir erro se o email for vazio", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     emailErrorController.add(UIError.requiredField);
//     await tester.pump();
//
//     expect(find.text(UIError.requiredField.descricao), findsOneWidget);
//   });
//
//   testWidgets("Deve exibir erro se o email for válido", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     emailErrorController.add("");
//     await tester.pump();
//
//     expect(find.descendant(of: find.bySemanticsLabel("Email"), matching: find.byType(Text)), findsOneWidget);
//   });
//
//   testWidgets("Deve exibir erro se a senha for inválida", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     passwordErrorController.add('any error');
//     await tester.pump();
//
//     expect(find.text('any error'), findsOneWidget);
//   });
//
//   testWidgets("Deve exibir erro se o email for válido", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     passwordErrorController.add("");
//     await tester.pump();
//
//     expect(find.descendant(of: find.bySemanticsLabel("Senha"), matching: find.byType(Text)), findsOneWidget);
//   });
//
//   testWidgets("Deve habilitar o botão de login se o formulário for válido", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     formValidController.add(true);
//     await tester.pump();
//
//     final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
//     expect(button.onPressed, isNotNull);
//   });
//
//   testWidgets("Deve habilitar o botão de login se o formulário for inválido", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     formValidController.add(false);
//     await tester.pump();
//
//     final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
//     expect(button.onPressed, null);
//   });
//
//   testWidgets("Deve chamar authentication no form submit", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     when(() => presenter.auth()).thenAnswer((_) => Future.value());
//
//     formValidController.add(true);
//     await tester.pump();
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pump();
//
//     verify(() => presenter.auth()).called(1);
//   });
//
//   testWidgets("Deve exibir loading", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     loadingController.add(true);
//     await tester.pump();
//
//     expect(find.byType(CircularProgressIndicator), findsOneWidget);
//   });
//
//   testWidgets("Deve esconder loading", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     loadingController.add(true);
//     await tester.pump();
//
//     loadingController.add(false);
//     await tester.pump();
//
//     expect(find.byType(CircularProgressIndicator), findsNothing);
//   });
//
//   testWidgets("Deve exibir mensagem de erro se authentication falhar", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     mainErrorController.add("main error");
//     await tester.pump();
//
//     expect(find.text("main error"), findsOneWidget);
//   });
//
//   testWidgets("Deve fechar todos os Streams quando a página for encerrada", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     addTearDown(() {
//       verify(() => presenter.dispose()).called(1);
//     });
//   });
//
//   testWidgets("Deve alterar a Page", (WidgetTester tester) async {
//     await loadPage(tester);
//
//     navigateToController.add("/any_route");
//     await tester.pumpAndSettle();
//
//     expect(Get.currentRoute, "/any_route");
//     expect(find.text("fake page"), findsOneWidget);
//   });
// }
