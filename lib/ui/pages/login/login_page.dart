import 'package:clean_architecture_tdd_solid/ui/components/error_snackbar.dart';
import 'package:clean_architecture_tdd_solid/ui/components/spinner_dialog.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/email_input.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/login_button.dart';
import 'package:clean_architecture_tdd_solid/ui/pages/login/components/password_input.dart';
import 'package:provider/provider.dart';
import '../../components/components.dart';
import 'login_presenter.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter? presenter;

  const LoginPage({Key? key, this.presenter}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter?.loadingStream?.listen((loading) {
            if (loading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });

          widget.presenter?.mainErrorStream?.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
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
                    create: (_) => widget.presenter,
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
                            label: const Text("Criar conta"),
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

  @override
  void dispose() {
    widget.presenter?.dispose();
    super.dispose();
  }
}
