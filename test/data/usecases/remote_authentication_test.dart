import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/domain/usecases/usecases.dart';

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
    Map body
  });
}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {
      'email': params.email,
      'password': params.password
    };

    await httpClient.request(
        url: url,
        method: 'POST',
        body: body
    );
  }
}

class HttpClientSpy extends Mock implements HttpClient {

}

main() {
  late String url;

  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;

  setUp(() {
      url = faker.internet.httpUrl();

      httpClient = HttpClientSpy();
      sut = RemoteAuthentication(
        httpClient: httpClient,
        url: url,
      );
  });

  test('Should call HttpClint with correct values', () async {
    final params = AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
    );

    await sut.auth(params);

    verify(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    ));
  });
}
