import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:app_for_dev/data/http/http.dart';

import 'package:app_for_dev/infra/http/http.dart';

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

    test('Should return BadRequestError if post returns 400', () async {
      mockPost(400, body: '');

      final future = sut.request(url: url, method: HttpMethod.post);

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return Unauthorized if post returns 401', () async {
      mockPost(401);

      final future = sut.request(url: url, method: HttpMethod.post);

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return Forbidden if post returns 403', () async {
      mockPost(403);

      final future = sut.request(url: url, method: HttpMethod.post);

      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return Forbidden if post returns 404', () async {
      mockPost(404);

      final future = sut.request(url: url, method: HttpMethod.post);

      expect(future, throwsA(HttpError.notFound));
    });

    test('Should return ServerError if post returns 500', () async {
      mockPost(500);

      final future = sut.request(url: url, method: HttpMethod.post);

      expect(future, throwsA(HttpError.serverError));
    });
  });

  group('Shared', () {
    test('Should throw ServerError if invalid method is provided', () {
      final future = sut.request(url: url, method: 'invalid_method');
      
      expect(future, throwsA(HttpError.serverError));
    });
  });
}
