import 'package:get/get.dart';

mixin LoadingManager on GetxController {
  final RxBool _loading = false.obs;

  Stream<bool> get loadingStream => _loading.stream;
  set loading(bool value) => _loading.value = value;
}