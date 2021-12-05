import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/data/http/http.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<dynamic> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final headers = HttpHeader.applicationJson;

    await client.post(Uri.parse(url), headers: headers, body: body);
  }
}

class ClientSpy extends Mock implements Client {

}

void main() {
  late String url;
  late Uri uri;

  late ClientSpy client;
  late HttpAdapter sut;

  setUp(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);

    client = ClientSpy();
    sut = HttpAdapter(client);

    registerFallbackValue(Uri());
  });

  group('POST', () {
    test('Should call post with correct values', () async {
      Map body = {};

      when(() => client.post(
          any(),
          headers: HttpHeader.applicationJson,
          body: body
      )).thenAnswer((_) async => Response('{}', 200));

      await sut.request(url: url, method: HttpMethod.post, body: body);

      verify(() => client.post(
          uri,
          headers: HttpHeader.applicationJson,
          body: body
      ));
    });
  });
}
