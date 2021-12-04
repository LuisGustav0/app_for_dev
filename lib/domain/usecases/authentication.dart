import '../entities/entities.dart';

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });

  Map toJson() => {
    'email': email,
    'password': password,
  };
}

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}
