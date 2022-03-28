import 'package:clean_architecture_tdd_solid/ui/pages/signup/signup_presenter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/error_snackbar.dart';
import '../../components/headline1.dart';
import '../../components/login_header.dart';
import '../../components/spinner_dialog.dart';
import '../../helpers/errors/ui_error.dart';
import '../../helpers/i18n/resources.dart';
import '../login/components/email_input.dart';
import '../login/components/password_input.dart';
import 'components/name_input.dart';
import 'components/password_confirmation_input.dart';
import 'components/signup_button.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  const SignUpPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.loadingStream.listen((loading) {
            if (loading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          presenter.mainErrorStream.listen((UIError? error) {
            if (error != null) {
              showErrorMessage(context, error.descricao);
            }
          });

          presenter.navigateToStream.listen((String? page) {
            if (page?.isNotEmpty ?? false) {
              Get.offAllNamed(page!);
            }
          });

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const LoginHeader(),
                Headline1(text: R.string.addAccount),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: ListenableProvider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          const NameInput(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          const PasswordInput(),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordConfirmationInput(),
                          ),
                          const SignUpButton(),
                          TextButton.icon(
                              onPressed: presenter.goToLogin,
                              icon: const Icon(Icons.exit_to_app),
                              label: Text(R.string.login)
                          )
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
