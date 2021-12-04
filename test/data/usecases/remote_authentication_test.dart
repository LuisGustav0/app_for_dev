import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class HttpClient {
  Future<void>? request({
    required String url,
    required String method,
  });
}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url, method: 'POST');
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
    await sut.auth();

    verify(() => httpClient.request(
        url: url,
        method: 'POST'
    ));
  });
}
