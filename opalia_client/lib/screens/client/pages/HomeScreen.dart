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
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Quiz du jour ",
                style: TextStyle(fontSize: 26),
              )),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment
                    .centerRight, // Aligns the container to the left side
                child: Container(
                  height: 130,
                  width: 350, // Set the desired width of the container
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.6), // Shadow color with opacity
                        spreadRadius: 3, // How far the shadow extends
                        blurRadius: 2.0, // Softness of the shadow
                        offset: Offset(1, 5), // Offset for x and y axes
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50.0),
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 35),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Aligns content to the center
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Jouez et gagnez",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: verif
                                  ? null
                                  : () async {
                                      await Get.to(ListQuizScreen());
                                      verify();
                                    },
                              child: Text(
                                verif
                                    ? 'Revenez dans \n une semaine'
                                    : 'Jouez au quiz',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: 60), // Adds space between text and image
                        Image.asset(
                            "assets/images/image.png"), // Image moved to the right
                      ],
                    ),
                  ),
                ),
              ),
          
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Actualités ",
                style: TextStyle(fontSize: 26),
              )),
              SizedBox(
                height: 15,
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
