import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/bloc/news/bloc/news_bloc.dart';
import 'package:opalia_client/screens/pages/news/DetailScreenNews.dart';
import 'package:opalia_client/widegts/News/NewsItem.dart';

import '../../models/news.dart';
import '../../services/apiService.dart';

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
          return Center(child: CircularProgressIndicator());
        } else if (model.hasError) {
          return Center(child: Text('Error: ${model.error}'));
        } else {
          return Container(
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
                // return Container(
                //   height: double.infinity,
                //   child: GridView.builder(
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2, // number of items in each row
                //       mainAxisSpacing: 8.0, // spacing between rows
                //       crossAxisSpacing: 8.0,
                //       // spacing between columns
                //     ),
                //     padding: const EdgeInsets.all(8.0), // padding around the grid
                //     itemCount: model.data!.length, // total number of items
                //     itemBuilder: (context, index) {
                //       final categorie = model.data![index];
                //       return NewsList(
                //         news: selcted,
                //       );
                // return GestureDetector(
                //   onTap: () {
                //     // Get.to(DetailProduct(medi: categorie));
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(20),
                //         border:
                //             Border.all(width: 2, color: Colors.red),
                //         color: Colors.white), // color of grid items
                //     child: Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Image.network(
                //             // categorie.categorieImage!,
                //             // height: 50,
                //             // width: 50,
                //             (categorie.mediImage == null ||
                //                     categorie.mediImage == "")
                //                 ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                //                 : categorie.mediImage!,
                //             height: 150,
                //             width: 100,
                //             fit: BoxFit.scaleDown,
                //           ),
                //           Text(
                //             categorie.mediname!,
                //             style: TextStyle(
                //                 fontSize: 15, color: Colors.red),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // );
              },
            ),
          );
        }
      },
    );
  }
}
