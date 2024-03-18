import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:opalia_client/config/config.dart';
import 'package:opalia_client/models/news.dart';
import 'package:http/http.dart' as http;
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<NewsInitialFetchEvent>(newsInitialFetchEvent);
  }

  var client = http.Client();
  FutureOr<void> newsInitialFetchEvent(
      NewsInitialFetchEvent event, Emitter<NewsState> emit) async {
    Map<String, String> requestHandler = {'Content-Type': 'application/json'};
    List<News> news = [];
    var url = Uri.http(Config.apiUrl, Config.newsAPI);
    var response = await client.get(url, headers: requestHandler);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        News medi = News.fromMap(data[i] as Map<String, dynamic>);
        news.add(medi);
      }
      print(data);
      emit(NewsFetchSucess(news: news));
    } else {
      throw Exception('Failed to load data news');
    }
  }
}
