import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class ClientSpy extends Mock implements Client {
  ClientSpy() {
    this.mockPost(200);
  }

  When mockPostCall() => when(() =>
      this.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers')
      )
  );
  void mockPost(int statusCode, {String body = '{"any_key":"any_value"}'}) =>
      this.mockPostCall().thenAnswer((_) async => Response(body, statusCode));

}