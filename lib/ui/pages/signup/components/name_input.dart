import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/errors/ui_error.dart';
import '../../../helpers/i18n/resources.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<UIError?>(
      stream: presenter.nameErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: R.string.name,
            icon: Icon(Icons.person, color: Theme.of(context).primaryColorLight),
            errorText: snapshot.data?.descricao,
          ),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
        );
      },
    );
  }
}