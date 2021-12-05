import 'package:app_for_dev/domain/entities/entities.dart';

class AuthenticationParams {
  final String email;
  final String password;

  AuthenticationParams({
    required this.email,
    required this.password,
  });
}

abstract class AuthenticationUseCase {
  Future<AccountEntity> auth(AuthenticationParams params);
}
