import 'package:clean_architecture_tdd_solid/ui/mixins/loading_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/navigation_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/mixins/ui_error_manager.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/email_input.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/login_button.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/password_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/i18n/resources.dart';
import 'login_presenter.dart';

class LoginPage extends StatelessWidget with LoadingManager, UIErrorManager, NavigationManager {
  final LoginPresenter presenter;

  const LoginPage({required this.presenter, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.loadingStream);
          handleMainError(context, presenter.mainErrorStream);
          handleNavigation(presenter.navigateToStream, clear: true);

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
                            label: Text(R.string.addAccount),
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
