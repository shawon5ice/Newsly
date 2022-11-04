


import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/data/repository/news_repository_implementation.dart';
import '../../home/domain/repository/news_repository.dart';
import '../../search/data/repository/news_repository_implementation.dart';
import '../../search/domain/repository/news_repository.dart';
import '../data/source/dio_client.dart';
import '../data/source/pref_manager.dart';
import '../logger/logger.dart';
import '../session/session_manager.dart';
import '../utils/constants.dart';

final locator = GetIt.instance;

class AppComponent {
  Future<void> init() async {
    locator.registerFactory<Dio>(() => Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 35000,
    ))
      ..interceptors.add(Logging()));
    locator.registerFactory<DioClient>(() => DioClient(locator<Dio>()));
    locator.registerFactory<HomeRepository>(() => NewsRepositoryImplementation());
    locator.registerFactory<SearchRepository>(() => NewsSearchRepositoryImplementation());
    locator.registerLazySingletonAsync<SessionManager>(() async => SessionManager(PrefManager(await SharedPreferences.getInstance())));
  }
}
