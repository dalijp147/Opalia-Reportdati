import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 270,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.news.newsImage!
                            .replaceFirst("file:///", "http://"),
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        size: 40.0,
                        weight: 50.0,
                      ),
                      onPressed: () {
                        Get.back();
                      }),
                  actions: [
                    IconButton(
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 40.0,
                        weight: 50.0,
                      ),
                      onPressed: () async {
                        setState(
                          () {
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
                          await HiveService.deleteDataFavoriteone(
                              widget.news.newsId);
                        }
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    widget.news.newsTitle!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight - 240,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/Grouhome.png',
                  ),
                  fit: BoxFit
                      .fill, // Adjust the image to cover the entire container
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Posté le ${formatter.format(widget.news.newsPublication!)}',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.news.newsDetail!,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
