import 'package:clean_architecture_tdd_solid/ui/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/navigation_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/ui_error_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/signup/signup_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/headline1.dart';
import '../../components/login_header.dart';
import '../../helpers/i18n/resources.dart';
import '../login/components/email_input.dart';
import '../login/components/password_input.dart';
import 'components/name_input.dart';
import 'components/password_confirmation_input.dart';
import 'components/signup_button.dart';

class SignUpPage extends StatelessWidget with LoadingManager, UIErrorManager, NavigationManager {
  final SignUpPresenter presenter;

  const SignUpPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.loadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream);

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
