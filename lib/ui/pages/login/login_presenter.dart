abstract class LoginPresenter {
  Stream<String> get emailErrorController;
  Stream<String> get passwordErrorController;
  Stream<bool> get formValidController;

  void validateEmail(String email);
  void validatePassword(String password);
}