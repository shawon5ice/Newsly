import 'package:newsly/core/data/model/api_response.dart';
import 'package:newsly/core/utils/end_points.dart';
import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/domain/repository/news_repository.dart';

import '../../../core/data/source/dio_client.dart';
import '../../../core/di/app_component.dart';
import '../../../core/logger/logger.dart';
import '../../../core/utils/messages.dart';

class NewsRepositoryImplementation implements HomeRepository {
  final DioClient _dioClient = locator<DioClient>();


  @override
  Future<Response<NewsResponse>?> fetchNews(
      {required Map<dynamic, dynamic> params}) async {
    Response<NewsResponse>? _apiResponse;
    await _dioClient.get(
      path: everyThing,
      request: params,
      // header: _dioClient.getHeader(locator<SessionManager>()),
      responseCallback: (response, message) {
        try {
          logger.printDebugLog('fetchJobs Response: $response');
          _apiResponse = Response.success(NewsResponse.fromJson(response));
        } catch (e) {
          logger.printErrorLog("fetchJobs Response broken: $e");
          _apiResponse = Response.error(tryAgainErrorMessage, 500);
        }
      },
      failureCallback: (message, statusCode) {
        logger.printErrorLog('fetchJobs Failed: $message : $statusCode');
        _apiResponse = Response.error(message, statusCode);
      },
    );

    return _apiResponse;
  }
}