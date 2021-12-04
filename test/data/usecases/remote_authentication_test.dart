import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/domain/usecases/usecases.dart';
import 'package:app_for_dev/domain/helpers/helpers.dart';

import 'package:app_for_dev/data/http/http.dart';
import 'package:app_for_dev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {

}

main() {
  late String url;

  late HttpClientSpy httpClient;
  late RemoteAuthentication sut;
  late AuthenticationParams params;

  setUp(() {
      url = faker.internet.httpUrl();

      params = AuthenticationParams(
        email: faker.internet.email(),
        password: faker.internet.password(),
      );

      httpClient = HttpClientSpy();
      sut = RemoteAuthentication(
        httpClient: httpClient,
        url: url,
      );
  });

  test('Should call HttpClient with correct values', () async {
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

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
