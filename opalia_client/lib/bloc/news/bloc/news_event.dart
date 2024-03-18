part of 'news_bloc.dart';

@immutable
sealed class NewsEvent {}

class NewsInitialFetchEvent extends NewsEvent {}
