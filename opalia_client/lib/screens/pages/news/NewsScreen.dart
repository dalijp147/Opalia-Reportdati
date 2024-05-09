import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opalia_client/bloc/news/bloc/news_bloc.dart';
import 'package:opalia_client/models/news.dart';
import 'package:opalia_client/screens/pages/news/DetailScreenNews.dart';
import 'package:opalia_client/widegts/News/NewsList.dart';

import '../../../services/apiService.dart';
import '../../../widegts/News/NewsItem.dart';
import '../chatbot/GemniScreen.dart';
import '../menu/MenuScreen.dart';
import '../menu/SettingsScreen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsBloc newsbloc = NewsBloc();
  @override
  void initState() {
    newsbloc.add(NewsInitialFetchEvent());
    super.initState();
  }

  List calender = [
    'Tous',
    'sante',
    'bien etre',
  ];

  String selcted = '';
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
                  colors: [Colors.red.shade50, Colors.white])),
        ),
        leading: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(
                  MenuScreen(),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.red,
              ))
        ],
        title: const Text(
          'OPALIA RECORDATI',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.activity,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Actualités',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 25),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 30,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: calender.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 2, left: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            selcted = calender[index].toString();
                            if (selcted == calender[0]) {
                              selcted = '';
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 1,
                            color: Colors.red,
                          ),
                        ),
                        height: 30,
                        width: 80,
                        child: Center(
                          child: Text(
                            calender[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selcted == calender[index].toString()
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            NewsList(
              news: selcted,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const ChatBot());
        },
        child: const Icon(
          Icons.chat,
        ),
      ),
    );
  }
}
