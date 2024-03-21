import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/news/bloc/news_bloc.dart';
import 'package:opalia_client/screens/pages/news/DetailScreenNews.dart';
import 'package:opalia_client/widegts/News/NewsItem.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final NewsBloc newsbloc = NewsBloc();
  @override
  void initState() {
    newsbloc.add(NewsInitialFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      bloc: newsbloc,
      listenWhen: (previous, current) => current is NewsActionState,
      buildWhen: (previous, current) => current is! NewsActionState,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case NewsFetchSucess:
            final sucessState = state as NewsFetchSucess;
            return Container(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sucessState.news.length,
                  itemBuilder: (context, index) {
                    final news = sucessState.news![index];
                    return GestureDetector(
                        onTap: () {
                          Get.to(DetailNews(
                            news: news,
                          ));
                        },
                        child: NewsItem(
                          model: news,
                        ));
                  },
                ));
          default:
            return Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Lottie.asset('assets/animation/heartrate.json',
                    height: 210, width: 210)
              ],
            );
        }
      },
    );
  }
}
