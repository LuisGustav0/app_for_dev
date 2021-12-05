import 'package:http/http.dart';

import 'package:app_for_dev/data/http/http.dart';

import 'package:app_for_dev/infra/http/http.dart';

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
    var response = Response('', HttpStatusCode.serverError);

    try {
      if(HttpMethod.isMethodPost(method)) {
        response = await client.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );
      }
    } catch(error) {
      throw HttpError.serverError;
    }

    return HttpAdapterHandleResponse.call(response);
  }
}