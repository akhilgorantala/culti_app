import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';
import 'logging_interceptor.dart';

class DioClient {
  late final String baseUrl;
  late final LoggingInterceptor? loggingInterceptor;
  late final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(
    this.baseUrl,
    Dio dioC, {
    this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    dio = dioC;
    dio!
      ..options.baseUrl = baseUrl
      ..httpClientAdapter
      ..options.headers = {
        'Accept': 'application/json; charset=UTF-8',
      };
    dio!.interceptors.add(loggingInterceptor!);
  }

  void updateToken(String newToken) {
    token = newToken;
    sharedPreferences.setString(AppConstants.TOKEN, token!);
    dio!.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool useAuth = false,
  }) async {
    try {
      options ??= Options();
      if (useAuth && token!.isNotEmpty) {
        options.headers = {
          ...?options.headers,
          'Authorization': 'Bearer $token',
        };
      }
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool useAuth = false,
  }) async {
    try {
      options ??= Options();
      if (useAuth && token!.isNotEmpty) {
        options.headers = {
          ...?options.headers,
          'Authorization': 'Bearer $token',
        };
      }
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool useAuth = false,
  }) async {
    try {
      options ??= Options();
      if (useAuth && token!.isNotEmpty) {
        options.headers = {
          ...?options.headers,
          'Authorization': 'Bearer $token',
        };
      }
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool useAuth = false,
  }) async {
    try {
      options ??= Options();
      if (useAuth && token!.isNotEmpty) {
        options.headers = {
          ...?options.headers,
          'Authorization': 'Bearer $token',
        };
      }
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
