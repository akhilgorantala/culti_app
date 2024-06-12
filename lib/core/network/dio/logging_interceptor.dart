import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      print("--> ${options.method} ${options.baseUrl}${options.path}");
      log("Headers: ${options.headers.toString()}");
      if (options.data is FormData) {
        FormData data = options.data;
        print("Data: ${jsonEncode(data.fields.toString())}");
      } else {
        print("Data: ${jsonEncode(options.data)}");
      }
      print("Query Parameters: ${options.queryParameters.toString()}");
      print("<-- END HTTP");
    } catch (e) {
      print("${e.toString()}");
    }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    print(
        "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}");

    String responseAsString = response.data.toString();

    if (responseAsString.length > maxCharactersPerLine) {
      int iterations = (responseAsString.length / maxCharactersPerLine).floor();
      for (int i = 0; i <= iterations; i++) {
        int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
        if (endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }
        print(
            responseAsString.substring(i * maxCharactersPerLine, endingIndex));
      }
    } else {
      print(response.data);
    }

    // print("<-- END HTTP");

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    // print(
    //     "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    return super.onError(err, handler);
  }
}
