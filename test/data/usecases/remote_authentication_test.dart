import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class HttpClient {
  Future<void>? request({
    required String url
  });
}

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

class HttpClientSpy extends Mock implements HttpClient {

}

main() {
  test('Should call HttpClint with correct URL', () async {
    final url = faker.internet.httpUrl();

    final httpClient = HttpClientSpy();
    final sut = RemoteAuthentication(
        httpClient: httpClient,
        url: url,
    );

    await sut.auth();

    verify(() => httpClient.request(url: url));
  });
}
