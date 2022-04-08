import 'package:get/get.dart';

mixin FormManager on GetxController {
  final _formValid = false.obs;

  Stream<bool> get formValidStream => _formValid.stream;
  set formValid(bool value) => _formValid.value = value;
}