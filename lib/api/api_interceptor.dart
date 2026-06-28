import 'package:http/http.dart' as http;

abstract class ApiInterceptor {
  Future<http.Request> interceptRequest(http.Request request);
  Future<http.Response> interceptResponse(http.Response response);
  Future<void> onError(Exception exception);
}

class LoggingInterceptor implements ApiInterceptor {
  @override
  Future<http.Request> interceptRequest(http.Request request) async {
    print('--> ${request.method} ${request.url}');
    return request;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    print('<-- ${response.statusCode} ${response.request?.url}');
    return response;
  }

  @override
  Future<void> onError(Exception exception) async {
    print('<-- Error: $exception');
  }
}

class HeadersInterceptor implements ApiInterceptor {
  @override
  Future<http.Request> interceptRequest(http.Request request) async {
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    return request;
  }

  @override
  Future<http.Response> interceptResponse(http.Response response) async {
    return response;
  }

  @override
  Future<void> onError(Exception exception) async {
    // No-op for headers
  }
}
