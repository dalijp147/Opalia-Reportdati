import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/screens/client/pages/quiz/SpinScreen.dart';

import '../../../bloc/news/bloc/news_bloc.dart';
import '../../../models/news.dart';
import '../../../services/local/sharedprefutils.dart';
import '../../../services/remote/apiService.dart';
import '../widgets/Allappwidgets/AppbarWidegts.dart';
import '../widgets/Allappwidgets/Drawerwidgets.dart';
import '../widgets/News/NewsList.dart';
import '../widgets/quiz/ListQuiz.dart';
import 'chatbot/GemniScreen.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class HomeScreenApp extends StatefulWidget {
  const HomeScreenApp({super.key});

  @override
  State<HomeScreenApp> createState() => _HomeScreenAppState();
}

class _HomeScreenAppState extends State<HomeScreenApp> {
  bool verif = false;
  List<News>? allNews = [];

  final NewsBloc newsbloc = NewsBloc();

  @override
  void initState() {
    super.initState();
    newsbloc.add(NewsInitialFetchEvent());
    verify();
    getWebsiteData();
  }

  Future<bool> verify() async {
    final x = await ApiService.getResultUserId(PreferenceUtils.getuserid());
    if (x == true) {
      setState(() {
        verif = x;
      });

      print("ok");
      print(verif);

      return verif;
    } else {
      print("error");
      return verif;
    }
  }

  Future<void> getWebsiteData() async {
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

  Future<void> _refreshData() async {
    await getWebsiteData();
    // Add any additional refresh logic here if needed
  }

  String selcted = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppbarWidgets(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/Grouhome.png'), // Replace with your image path
              fit: BoxFit.cover, // Adjust the image to cover the entire screen
            ),
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.game,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Quiz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    color: Colors.white70,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/animation/trophy.json',
                          width: 120,
                          height: 120,
                          filterQuality: FilterQuality.high,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        verif
                            ? Text(
                                'Pardon',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              )
                            : Text(
                                'Participer au quiz',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        verif
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Tu a deja partcipé au quiz , passer nous voire une prochaine fois.',
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(250, 20)),
                                onPressed: () {
                                  verify();
                                  Get.to(ListQuizScreen());
                                },
                                child: Text('Jouez',
                                    style: TextStyle(fontSize: 25)),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
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
                      'Actualité',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 25),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
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
                              selcted =
                                  allNews![index].categorienews!.toString();
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
              const SizedBox(
                height: 10,
              ),
              NewsList(
                news: selcted,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const ChatBot());
        },
        child: Image.asset(
          'assets/images/Group.png',
          height: 30,
        ),
      ),
    );
  }
}
