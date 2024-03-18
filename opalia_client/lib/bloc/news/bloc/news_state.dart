part of 'news_bloc.dart';

@immutable
sealed class NewsState {}

sealed class NewsActionState extends NewsState {}

final class NewsInitial extends NewsState {}

class NewsFetchSucess extends NewsState {
  final List<News> news;
  NewsFetchSucess({required this.news});
}
