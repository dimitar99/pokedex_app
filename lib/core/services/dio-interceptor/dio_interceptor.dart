import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pokedex_app/layers/presentation/shared/constants/constants.dart';

/// Base Options for Dio calls
BaseOptions dioOptions = BaseOptions(
  baseUrl: Constants.baseUrl,
  sendTimeout: Constants.timeOut,
  connectTimeout: Constants.timeOut,
  receiveTimeout: Constants.timeOut,
);

class DioInterceptor {
  Dio dio = Dio(dioOptions);
  DioInterceptor();

  Dio request() {
    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (request, handler) async {
          log('\x1B[36m--- DioInterceptor.onRequest() -> (PATH: [${request.path}]\x1B[0m');
          handler.next(request);
        },
        onError: (error, handler) async {
          log('\x1B[31m--- DioInterceptor.onError() -> STATUS CODE [${error.response?.statusCode}] PATH [${error.requestOptions.path}]\x1B[0m');
          await _manageDioException(error: error, handler: handler);
        },
        onResponse: (response, handler) async {
          log('\x1B[32m--- DioInterceptor.onResponse() -> STATUS CODE [${response.statusCode}] STATUS MESSAGE [${response.statusMessage}]\x1B[0m');
          handler.next(response);
        },
      ),
    );
    return dio;
  }

  Future _manageDioException({required DioException error, required ErrorInterceptorHandler handler}) async {
    log('------ DioInterceptor_manageDioException -> ${error.response?.statusCode}');
    if (error.response?.statusCode == null) {
      handler.reject(error);
      return;
    }

    try {
      await _retryRequest(error.requestOptions, handler);
    } catch (_) {
      handler.reject(error);
    }
  }

  Future _retryRequest(RequestOptions requestOptions, ErrorInterceptorHandler handler) async {
    log('------ DioInterceptor._retryRequest()');

    final opts = Options(validateStatus: (_) => true, method: requestOptions.method, responseType: requestOptions.responseType);

    dynamic response;
    try {
      response = await dio.request(requestOptions.path, options: opts, data: requestOptions.data, queryParameters: requestOptions.queryParameters);
      handler.resolve(response);
    } on DioException catch (error) {
      log('------ DioException -> $error');
      handler.reject(error);
    } on TimeoutException catch (_) {
      log('------ TimeoutException');
      handler.reject(DioException(requestOptions: requestOptions));
    }
    return response;
  }

  bool isValidResponse(Response response) {
    if ((response.statusCode ?? 400) >= 200 && (response.statusCode ?? 400) < 300) {
      return true;
    } else {
      return false;
    }
  }
}
