import 'package:flutter/material.dart';

import '../components/error_snackbar.dart';
import '../helpers/errors/ui_error.dart';

mixin UIErrorManager {
  void handleMainError(BuildContext context, Stream<UIError?> stream) {
    stream.listen((error) {
      if (error != null) {
        showErrorMessage(context, error.descricao);
      }
    });
  }
}