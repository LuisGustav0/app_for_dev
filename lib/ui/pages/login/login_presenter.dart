abstract class LoginPresenter {
  Stream<String> get emailErrorController;

  void validateEmail(String email);
  void validatePassword(String password);
}