import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hive/hive.dart';
import 'package:opalia_client/models/news.dart';

import '../../../services/local/hive_Service.dart';
import '../../widegts/News/NewsItem.dart';

class DetailNews extends StatefulWidget {
  final News news;

  const DetailNews({super.key, required this.news});

  @override
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  @override
  void initState() {
    _refrechFavoriteItems();

    super.initState();
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
    var isFavorite = boxFavorite.get(_items) != null;
    return Scaffold(
      appBar: AppBar(
        actions: [
          isFavorite
              ? IconButton(
                  onPressed: () async {
                    //HiveService.readDataFavorite();
                    await HiveService.deleteDataFavoriteone(
                        widget.news.newsId!);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    await HiveService.writeDataFavorite(
                      {
                        "namenews": widget.news.newsTitle,
                        "isnews": widget.news.newsId,
                        "newsImage": widget.news.newsImage,
                        "newsDate": widget.news.newsPublication,
                        "random": randomNumber
                      },
                    );
                    setState(() {
                      isFavorite = false;
                    });
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          const Icon(Icons.share_outlined)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.news.newsImage!
                          .replaceFirst("file:///", "http://"),
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.news.newsTitle!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.news.newsDetail!,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Related News",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 500,
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  //final medicament = allMedicament![index];
                  return GestureDetector(
                    onTap: () {
                      // Get.to(DetailProduct(
                      //   image: medicament.mediImage!,
                      //   title: medicament.mediname!,
                      // ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 250,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 2, color: Colors.red),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Image.network(
                              // categorie.categorieImage!,
                              // height: 50,
                              // width: 50,
                              // (medicament.mediImage == null ||
                              //         medicament.mediImage == "")
                              //     ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                              //     : medicament.mediImage!,
                              // height: 100,
                              // width: 100,
                              // fit: BoxFit.scaleDown,
                              //   ),
                              Text(
                                //  medicament.mediname!,
                                'Test',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
