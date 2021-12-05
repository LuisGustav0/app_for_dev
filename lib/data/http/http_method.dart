class HttpMethod {

  static const String post = 'POST';

  static bool isMethodPost(String method) {
    return post == method.toUpperCase();
  }
}