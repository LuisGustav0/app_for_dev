import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

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