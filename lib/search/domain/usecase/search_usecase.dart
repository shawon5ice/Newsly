import '../repository/news_repository.dart';

abstract class SearchUsecase{
  final SearchRepository searchRepository;
  SearchUsecase(this.searchRepository);
}