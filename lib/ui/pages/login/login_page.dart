import 'package:clean_architecture_tdd_solid/ui/components/error_snackbar.dart';
import 'package:clean_architecture_tdd_solid/ui/components/spinner_dialog.dart';
import 'package:clean_architecture_tdd_solid/ui/helpers/errors/ui_error.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/email_input.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/login_button.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/password_input.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import 'login_presenter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final LoginPresenter presenter;

  const LoginPage({required this.presenter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.loadingStream?.listen((loading) {
            if (loading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.mainErrorStream?.listen((UIError? error) {
            if (error != null) {
              showErrorMessage(context, error.descricao);
            }
          });

          presenter.navigateToStream?.listen((String? page) {
            if (page?.isNotEmpty ?? false) {
              Get.offAllNamed(page!);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                Headline1(text: "Login".toUpperCase()),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: [
                          const EmailInput(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordInput(),
                          ),
                          const LoginButton(),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person),
                            label: Text(R.strings.addAccount),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
