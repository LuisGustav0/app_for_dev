import 'dart:convert';

import 'package:http/http.dart';

import 'package:app_for_dev/data/http/http.dart';

class HttpAdapterHandleResponse {
  static Map call(Response response) {
    switch (response.statusCode) {
      case HttpStatusCode.ok:
        return response.body.isEmpty ? {} : jsonDecode(response.body);
      case HttpStatusCode.noContent:
        return {};
      case HttpStatusCode.badRequest:
        throw HttpError.badRequest;
      case HttpStatusCode.unauthorized:
        throw HttpError.unauthorized;
      case HttpStatusCode.forbidden:
        throw HttpError.forbidden;
      default:
        throw HttpError.serverError;
    }
  }
}
