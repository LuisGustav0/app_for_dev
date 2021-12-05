import 'dart:convert';

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  @override
  Future<Map> request({
    required String url,
    required String method,
    Map? headers,
    Map? body,
  }) async {
    final headers = HttpHeader.applicationJson;

    final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body,
    );

    if(HttpStatusCode.isNoContent(response.statusCode)
        || response.body.isEmpty) {
      return {};
    }

    return jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements Client {

}

void main() {
  late String url;
  late Uri uri;

  late ClientSpy client;
  late HttpAdapter sut;

  When mockPostCall() => when(() =>
      client.post(
        any(),
        body: any(named: 'body'),
        headers: any(named: 'headers'),
      ),
  );

  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      mockPostCall().thenAnswer((_) async => Response(body, statusCode));

  setUp(() {
    url = faker.internet.httpUrl();
    uri = Uri.parse(url);

    client = ClientSpy();
    sut = HttpAdapter(client);

    registerFallbackValue(Uri());

    mockPost(200);
  });

  group('POST', () {
    test('Should call post with correct values', () async {
      Map body = {'any_key': 'any_value'};

      await sut.request(url: url, method: HttpMethod.post, body: body);

      verify(() => client.post(
          uri,
          headers: HttpHeader.applicationJson,
          body: body
      ));
    });

    test('Should call post without body', () async {
      await sut.request(url: url, method: HttpMethod.post);

      verify(() => client.post(
          uri,
          headers: any(named: 'headers')
      ));
    });

    test('Should return data if post returns 200', () async {
      Map body = {'any_key': 'any_value'};

      when(() => client.post(
        any(),
        headers: any(named: 'headers'),
      )).thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      final response = await sut.request(url: url, method: HttpMethod.post);

      expect(response, body);
    });

    test('Should return data if post returns 200 with no data', () async {
      mockPost(200, body: '');

      final response = await sut.request(url: url, method: HttpMethod.post);

      expect(response, {});
    });

    test('Should return {} if post returns 204 with data', () async {
      mockPost(204);

      final response = await sut.request(url: url, method: HttpMethod.post);

      expect(response, {});
    });
  });
}
