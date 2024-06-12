import 'package:culti_app/provider/configure_provider.dart';
import 'package:culti_app/provider/date_format_provider.dart';
import 'package:culti_app/provider/home_provider.dart';
import 'package:culti_app/provider/mqtt_provider.dart';
import 'package:culti_app/provider/user_provider.dart';
import 'package:culti_app/repo/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio/dio_client.dart';
import 'core/network/dio/logging_interceptor.dart';
import 'core/utils/app_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => DioClient(AppConstants.BASE_URL, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  //repository
  sl.registerLazySingleton(
      () => AuthRepository(sharedPreferences: sl(), dioClient: sl()));

  //provider
  sl.registerFactory(() => HomeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => ConfigureProvider(
      repository: sl(), sharedPreferences: sl(), dioClient: sl()));
  sl.registerFactory(() => MQTTProvider(sharedPreferences: sl()));
  sl.registerFactory(() => UserProvider(sharedPreferences: sl()));
  sl.registerFactory(() => DateFormatProvider());

  //external
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
