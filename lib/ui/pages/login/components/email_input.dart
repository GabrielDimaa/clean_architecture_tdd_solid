import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_presenter.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginPresenter presenter = Provider.of<LoginPresenter>(context);

    return StreamBuilder<String?>(
      stream: presenter.emailErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: "Email",
            errorText: (snapshot.data?.isEmpty ?? true) ? null : snapshot.data,
            icon: Icon(
              Icons.email,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onChanged: presenter.validateEmail,
        );
      },
    );
  }
}
