import 'package:newsly/home/data/model/news_response.dart';

import '../../../core/data/model/api_response.dart';

abstract class HomeRepository {
  Future<Response<NewsResponse>?> fetchNews({required Map<dynamic, dynamic> params});
}