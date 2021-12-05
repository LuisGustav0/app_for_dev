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
    final accountFake = {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name()
    };

    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenAnswer((_) async => accountFake);

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

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 401', () async {
    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return Account if HttpClient returns 200', () async {
    final accountFake = {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name()
    };

    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenAnswer((_) async => accountFake);

    final account = await sut.auth(params);

    expect(account.token, accountFake['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    final accountFake = {
      'invalid_key': 'invalid_value',
    };

    when(() => httpClient.request(
        url: url,
        method: 'POST',
        body: {
          'email': params.email,
          'password': params.password,
        }
    )).thenAnswer((_) async => accountFake);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
