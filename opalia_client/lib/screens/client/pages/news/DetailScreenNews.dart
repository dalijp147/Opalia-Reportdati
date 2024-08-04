import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/news.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../../services/local/hive_Service.dart';
import '../../../../services/remote/apiService.dart';
import 'ReleatedActualié.dart';

class DetailNews extends StatefulWidget {
  final News news;

  const DetailNews({super.key, required this.news});

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  bool _isFavorite = false;
  @override
  void initState() {
    _refrechFavoriteItems();
    _checkIfFavorite();
    super.initState();
  }

  void _checkIfFavorite() {
    final itemExists = HiveService.itemExists(widget.news.newsId);
    if (itemExists) {
      final item = HiveService.boxFavorite.get(widget.news.newsId)
          as Map<String, dynamic>?;
      setState(() {
        _isFavorite = item?['favorite'] ?? false;
      });
    }
  }

  List<Map<String, dynamic>> _items = [];
  final boxFavorite = Hive.box('favoriteBox');
  void _refrechFavoriteItems() {
    setState(() {
      _items = HiveService.refrechFavoriteItem().toList();
    });
    print(_items);
  }

  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    int randomNumber = random.nextInt(1000);
    // var isFavorite = boxFavorite.get("isnews") != null;
    var formatter = DateFormat('EEEE, d MMMM yyyy à HH:mm', 'fr_FR');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            // onPressed: () async {
            //   await HiveService.writeDataFavorite(
            //     {
            //       "namenews": widget.news.newsTitle,
            //       "isnews": widget.news.newsId,
            //       "newsImage": widget.news.newsImage,
            //       "newsDate": widget.news.newsPublication,
            //       "random": randomNumber
            //     },
            //   );
            // },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              setState(
                () {
                  //boxFavorite.get
                  _isFavorite = !_isFavorite;
                },
              );

              if (_isFavorite) {
                await HiveService.writeDataFavorite(
                  {
                    "namenews": widget.news.newsTitle,
                    "isnews": widget.news.newsId,
                    "newsImage": widget.news.newsImage,
                    "newsDate": widget.news.newsPublication,
                    "random": randomNumber,
                    "favorite": true
                  },
                );
              } else {
                await HiveService.deleteDataFavoriteone(widget.news.newsId);
              }
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.news.newsImage!.replaceFirst("file:///", "http://"),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.news.newsTitle!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'poster le ${formatter.format(widget.news.newsPublication!)}',
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.news.newsDetail!,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Autre Actualité :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<List<News>>(
              future: ApiService.getnewsbycategorie(widget.news.categorienews!),
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
                              child:
                                  Text('Pas d actualite pour cette categorie'),
                            ),
                          ],
                        )
                      : Container(
                          width: 500,
                          height: 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: model.data!.length,
                            itemBuilder: (context, index) {
                              final news = model.data![index];
                              return RelatedActualieItem(
                                imageNews: news.newsImage!,
                                nameNews: news.newsTitle!,
                                desc: news.newsDetail!,
                              );
                            },
                          ),
                        );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
