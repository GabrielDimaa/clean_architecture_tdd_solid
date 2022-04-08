import '../../helpers/errors/ui_error.dart';

abstract class LoginPresenter {
  Stream<UIError?> get emailErrorStream;
  Stream<UIError?> get passwordErrorStream;
  Stream<UIError?> get mainErrorStream;
  Stream<bool> get formValidStream;
  Stream<bool> get loadingStream;
  Stream<String?> get navigateToStream;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void goToSignUp();
  void dispose();
}