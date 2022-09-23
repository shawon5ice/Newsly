import 'package:equatable/equatable.dart';
import 'package:newsly/home/data/model/news_response.dart';

// part 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchNewsEvent extends HomeEvent {
  final int nextPageIndex;
  final List<Articles> existingList;
  const FetchNewsEvent(this.nextPageIndex,this.existingList);
  @override
  List<Object?> get props => [];
}
