import '../entities/entities.dart';

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });
}

abstract class Authentication {
  Future<AccountEntity> auth(AuthenticationParams params);
}
