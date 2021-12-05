class HttpStatusCode {

  static int get noContent => 204;

  static bool isNoContent(int statusCode) => statusCode == noContent;
}