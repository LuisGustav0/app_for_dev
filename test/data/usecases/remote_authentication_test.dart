import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/data/http/http.dart';
import 'package:app_for_dev/data/usecases/usecases.dart';
import 'package:app_for_dev/domain/usecases/usecases.dart';

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
