import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/news/bloc/news_bloc.dart';
import 'package:opalia_client/screens/pages/news/DetailScreenNews.dart';
import 'package:opalia_client/services/local/hive_Service.dart';
import 'package:opalia_client/screens/widegts/News/NewsItem.dart';

import '../../../models/news.dart';
import '../../../services/remote/apiService.dart';

class NewsList extends StatefulWidget {
  final String news;
  const NewsList({super.key, required this.news});

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
    return FutureBuilder<List<News>>(
      future: ApiService.getnewsbycategorie(widget.news),
      builder: (BuildContext context, AsyncSnapshot<List<News>> model) {
        if (model.connectionState == ConnectionState.waiting) {
          return Column(children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ]);
        } else if (model.hasError) {
          return Center(child: Text('Error: ${model.error}'));
        } else {
          return model.data!.isEmpty
              ? Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Text('Pas d actualite pour cette categorie'),
                    ),
                  ],
                )
              : Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.data!.length, // total number of items
                    itemBuilder: (context, index) {
                      final news = model.data![index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(DetailNews(
                            news: news,
                          ));
                        },
                        child: NewsItem(
                          model: news,
                        ),
                      );
                    },
                  ),
                );
        }
      },
    );
  }
}
