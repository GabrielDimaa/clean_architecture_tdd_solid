import 'package:get/get.dart';

mixin SessionManager on GetxController {
  final RxBool _sessionExpired = false.obs;

  Stream<bool> get sessionExpiredStream => _sessionExpired.stream;
  set sessionExpired(bool value) => _sessionExpired.value = value;
}