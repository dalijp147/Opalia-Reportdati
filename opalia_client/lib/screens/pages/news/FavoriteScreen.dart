import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/services/local/hive_Service.dart';

import 'DetailScreenNews.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Map<String, dynamic>> _items = [];
  final boxFavorite = Hive.box('favoriteBox');
  void _refrechFavoriteItems() {
    setState(() {
      _items = HiveService.refrechFavoriteItem().reversed.toList();
    });
  }

  void deleteItemsnews(key) {
    HiveService.deleteDataFavoriteone(key);
    _refrechFavoriteItems();
  }

  @override
  void initState() {
    _refrechFavoriteItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _items.isEmpty
          ? Center(
              child: Lottie.asset(
                'assets/animation/emptybox.json',
                height: 210,
                width: 210,
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, index) {
                final currentItem = _items[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.shade100,
                      ),
                      width: 50,
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            currentItem['newsImage'],
                            width: 100,
                          ),
                          Text(
                            currentItem['namenews'],
                          ),
                          IconButton(
                            onPressed: () {
                              deleteItemsnews(
                                currentItem['key'],
                              );
                            },
                            icon: Icon(Icons.delete),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
