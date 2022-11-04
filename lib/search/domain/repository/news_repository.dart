
import 'package:newsly/search/data/model/news_response.dart';

import '../../../core/data/model/api_response.dart';

abstract class SearchRepository {
  Future<Response<NewsResponse>?> fetchNews({required Map<String, String> params});
}