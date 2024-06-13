import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opalia_client/bloc/news/bloc/news_bloc.dart';
import 'package:opalia_client/models/news.dart';


import '../../widgets/Allappwidgets/AppbarWidegts.dart';
import '../../widgets/Allappwidgets/Drawerwidgets.dart';
import '../../widgets/News/NewsList.dart';
import '../chatbot/GemniScreen.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<News>? allNews = [];

  final NewsBloc newsbloc = NewsBloc();
  @override
  void initState() {
    newsbloc.add(NewsInitialFetchEvent());
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse("https://www.opaliarecordati.com/fr/articles");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('div.bloc_left.left > ul > li > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    print('count ${titles.length}');
    setState(() {
      allNews = List.generate(titles.length,
          (index) => News(categorienews: titles[index].toString()));
    });
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
      drawer: DrawerWidget(),
      appBar: AppbarWidgets(),
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
              height: 100,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: allNews!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 2, left: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            selcted = allNews![index].categorienews!.toString();
                            if (selcted == allNews![0]) {
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
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(3.5),
                            child: Text(
                              allNews![index].categorienews!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: selcted ==
                                        allNews![index]
                                            .categorienews!
                                            .toString()
                                    ? Colors.red
                                    : Colors.black,
                              ),
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
