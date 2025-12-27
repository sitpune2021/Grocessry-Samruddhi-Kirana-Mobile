import 'dart:developer';

class ApiLogger {
  static void request({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    log('━━━━━━━━━━━━━━ API REQUEST ━━━━━━━━━━━━━━');
    log('METHOD   : $method');
    log('URL      : $url');
    if (headers != null) log('HEADERS  : $headers');
    if (body != null) log('BODY     : $body');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void response({
    required String url,
    required int statusCode,
    required String body,
  }) {
    log('━━━━━━━━━━━━━━ API RESPONSE ━━━━━━━━━━━━━');
    log('URL         : $url');
    log('STATUS CODE : $statusCode');
    log('RESPONSE    : $body');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void error({required String url, required dynamic error}) {
    log('━━━━━━━━━━━━━━ API ERROR ━━━━━━━━━━━━━━━━');
    log('URL   : $url');
    log('ERROR : $error');
    log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }
}
