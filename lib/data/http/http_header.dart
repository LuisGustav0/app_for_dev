class HttpHeader {
  static Map<String, String> get contentType =>
      {'content-type': 'application/json'};

  static Map<String, String> get acceptType =>
      {'accept-type': 'application/json'};

  static Map<String, String> get applicationJson =>
      {...contentType, ...acceptType};
}
