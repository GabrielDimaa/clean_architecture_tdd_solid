import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/ui_error.dart';
import '../../../helpers/i18n/resources.dart';
import '../signup_presenter.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.string.password,
            icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.data?.descricao,
          ),
          obscureText: true,
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}