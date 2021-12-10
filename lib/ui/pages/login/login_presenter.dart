abstract class LoginPresenter {
  Stream<String> get emailErrorController;
  Stream<String> get passwordErrorController;

  void validateEmail(String email);
  void validatePassword(String password);
}