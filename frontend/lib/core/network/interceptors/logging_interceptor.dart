import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Intercepteur Dio pour journaliser les requêtes et réponses HTTP.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '→ ${options.method} ${options.uri}\n'
      '  Headers: ${options.headers}\n'
      '  Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      '← ${response.statusCode} ${response.requestOptions.uri}\n'
      '  Data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✗ ${err.type} ${err.requestOptions.uri}\n'
      '  Message: ${err.message}\n'
      '  Response: ${err.response?.data}',
    );
    handler.next(err);
  }
}
