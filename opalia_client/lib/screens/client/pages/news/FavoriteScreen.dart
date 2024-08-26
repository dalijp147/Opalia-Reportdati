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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: [1, 0.1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.red.shade50, Colors.white],
            ),
          ),
        ),
        title: Text(
          'Actualitée favorites',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Image.network(
                              currentItem['newsImage'],
                              width: double.infinity,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                currentItem['namenews'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteItemsnews(currentItem['key']);
                            },
                            icon: Icon(Icons.delete),
                          ),
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
