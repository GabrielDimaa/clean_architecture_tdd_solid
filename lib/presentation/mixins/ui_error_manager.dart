import 'package:get/get.dart';

import '../../ui/helpers/errors/ui_error.dart';

mixin UIErrorManager on GetxController {
  final Rxn<UIError> _mainError = Rxn<UIError>();

  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}