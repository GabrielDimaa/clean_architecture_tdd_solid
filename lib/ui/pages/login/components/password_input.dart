import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_presenter.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginPresenter presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String>(
      stream: presenter.passwordErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Senha",
            errorText: (snapshot.data?.isEmpty ?? true) ? null : snapshot.data,
            icon: Icon(
              Icons.lock,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onChanged: presenter.validatePassword,
        );
      },
    );
  }
}
