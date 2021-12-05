import 'package:app_for_dev/data/http/http.dart';
import 'package:app_for_dev/data/models/models.dart';

import 'package:app_for_dev/domain/entities/entities.dart';
import 'package:app_for_dev/domain/helpers/helpers.dart';
import 'package:app_for_dev/domain/usecases/usecases.dart';

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.password);

  Map toJson() => {
    'email': email,
    'password': password,
  };
}

class RemoteAuthenticationUseCaseImpl implements AuthenticationUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteAuthenticationUseCaseImpl({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final body = RemoteAuthenticationParams.fromDomain(params).toJson();

      final httpResponse = await httpClient.request(
        url: url,
        method: 'POST',
        body: body,
      );

      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}