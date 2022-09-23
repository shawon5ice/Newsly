import 'package:newsly/home/data/model/news_response.dart';
import 'package:newsly/home/domain/usecase/home_usecase.dart';

import '../../../core/data/model/api_response.dart';
import '../../../core/utils/messages.dart';
import '../repository/news_repository.dart';


class FetchNewsUseCase extends HomeUseCase {
FetchNewsUseCase( dashboardRepository)
: super(dashboardRepository);

Future<Response<NewsResponse>?> fetchNews({required Map<dynamic, dynamic> params}) async {
  var response = await homeRepository.fetchNews(
    params: params,
  );
  if (response != null && response.status == Status.success) {
    if (response.data != null &&
        response.data?.status == "ok") {
      response = Response.success(response.data);
    } else {
      response = Response.error(
          "There is a problem!", int.parse('401'));
    }
  } else {
    response = Response.error(response?.message ?? tryAgainErrorMessage, 500);
  }

  return response;

}
}