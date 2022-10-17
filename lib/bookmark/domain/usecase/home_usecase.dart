import '../repository/news_repository.dart';

abstract class HomeUseCase{
  final HomeRepository homeRepository;
  HomeUseCase(this.homeRepository);
}