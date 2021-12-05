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
  late RemoteAuthenticationUseCaseImpl sut;
  late AuthenticationParams params;

  When mockRequest() {
    return when(() => httpClient.request(
      url: url,
      method: 'POST',
      body: {
        'email': params.email,
        'password': params.password,
      })
    );
  }

  void mockHttpData(Map data) => mockRequest().thenAnswer((_) async => data);

  void mockHttpError(HttpError error) => mockRequest().thenThrow(error);

  Map mockValidData() => {
    'accessToken': faker.guid.guid(),
    'name': faker.person.name()
  };

  setUp(() {
    url = faker.internet.httpUrl();

    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );

    httpClient = HttpClientSpy();

    sut = RemoteAuthenticationUseCaseImpl(
      httpClient: httpClient,
      url: url,
    );

    mockHttpData(mockValidData());
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
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 401', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return Account if HttpClient returns 200', () async {
    final accountFake = {
      'accessToken': faker.guid.guid(),
      'name': faker.person.name()
    };

    mockHttpData(accountFake);

    final account = await sut.auth(params);

    expect(account.token, accountFake['accessToken']);
  });

  test('Should throw UnexpectedError if HttpClient returns 200 with invalid data', () async {
    final accountFake = {
      'invalid_key': 'invalid_value',
    };

    mockHttpData(accountFake);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
