import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/models/categorieNews.dart';
import 'package:opalia_client/screens/client/pages/quiz/SpinScreen.dart';
import 'package:opalia_client/screens/pro/pages/calculator/CalculatorScreen.dart';
import 'package:opalia_client/screens/pro/widgets/quiz/ListQuizPro.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/news/bloc/news_bloc.dart';
import '../../../models/news.dart';
import '../../../services/local/sharedprefutils.dart';
import '../../../services/remote/apiService.dart';

import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../../client/pages/chatbot/GemniScreen.dart';
import '../../client/widgets/News/NewsList.dart';
import '../../client/widgets/quiz/ListQuiz.dart';
import '../widgets/Allappwidgets/AppBarWidgetPro.dart';
import '../widgets/Allappwidgets/Drawerwidgets.dart';

class HomeScreenAppPRo extends StatefulWidget {
  const HomeScreenAppPRo({super.key});

  @override
  State<HomeScreenAppPRo> createState() => _HomeScreenAppPRoState();
}

class _HomeScreenAppPRoState extends State<HomeScreenAppPRo> {
  bool verif = false;
  List<News>? allNews = [];
  bool isButtonVisible = true;

  final NewsBloc newsbloc = NewsBloc();
  List<CategorieNews>? allCategorieNews = [];
  Future<void> fetchMedicament() async {
    try {
      final CategorieNews = await ApiServicePro.getAllCategoryNews();
      setState(() {
        allCategorieNews = CategorieNews;
      });
    } catch (e) {
      print('Failed to fetch categorie News: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    newsbloc.add(NewsInitialFetchEvent());
    verify();
    fetchMedicament();
    getWebsiteData();
  }

  void startButtonTimer() {
    Future.delayed(Duration(minutes: 1), () {
      setState(() {
        isButtonVisible = true;
      });
    });
  }

  // Future<bool> verify() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? lastParticipationTimestamp =
  //       prefs.getInt('lastParticipationTimestamp');

  //   if (lastParticipationTimestamp != null) {
  //     DateTime lastParticipation =
  //         DateTime.fromMillisecondsSinceEpoch(lastParticipationTimestamp);
  //     DateTime now = DateTime.now();
  //     Duration difference = now.difference(lastParticipation);

  //     if (difference.inDays >= 7) {
  //       setState(() {
  //         verif = false;
  //       });
  //       return false;
  //     }
  //   }

  //   final x = await ApiService.getResultdoctorId(PreferenceUtils.getuserid());
  //   setState(() {
  //     verif = x;
  //   });

  //   if (x) {
  //     // Store the current timestamp as the last participation date
  //     await prefs.setInt(
  //         'lastParticipationTimestamp', DateTime.now().millisecondsSinceEpoch);
  //   }

  //   print("ok");
  //   print(verif);
  //   return verif;
  // }
  Future<bool> verify() async {
    final x = await ApiService.getResultdoctorId(PreferenceUtils.getuserid());
    setState(() {
      verif = x;
      isButtonVisible = !x;
    });

    if (x) {
      startButtonTimer();
    }

    print("ok");
    print(verif);
    return verif;
  }

  Future<String> getTimeUntilNextParticipation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastParticipationTimestamp =
        prefs.getInt('lastParticipationTimestamp');

    if (lastParticipationTimestamp != null) {
      DateTime lastParticipation =
          DateTime.fromMillisecondsSinceEpoch(lastParticipationTimestamp);
      DateTime nextParticipation = lastParticipation.add(Duration(days: 7));
      Duration remaining = nextParticipation.difference(DateTime.now());

      if (remaining.isNegative) {
        return "Vous pouvez participer maintenant";
      } else {
        return "${remaining.inDays} jours, ${remaining.inHours % 24} heures, ${remaining.inMinutes % 60} minutes";
      }
    }

    return "Vous pouvez participer maintenant";
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
      drawer: DrawerWidgetPro(),
      appBar: AppBarWidget(),
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
                height: 10,
              ),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Iconsax.game,
              //         color: Colors.red,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text(
              //         'Quiz',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Colors.red,
              //           fontSize: 25,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 40,
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     width: 250,
              //     height: 250,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         20,
              //       ),
              //       color: Color.fromARGB(0, 0, 0, 0),
              //     ),
              //     child: Center(
              //       child: Column(
              //         children: [
              //           Lottie.asset(
              //             'assets/animation/trophy.json',
              //             width: 120,
              //             height: 150,
              //             filterQuality: FilterQuality.high,
              //           ),
              //           SizedBox(
              //             height: 10,
              //           ),
              //           ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //               fixedSize: Size(350, 50),
              //             ),
              //             onPressed: verif
              //                 ? null
              //                 : () async {
              //                     await Get.to(ListQuizScreenPro());
              //                     verify();
              //                   },
              //             child: Text(
              //               verif
              //                   ? 'Revenez dans une semaine'
              //                   : 'Jouez au quiz',
              //               style: TextStyle(fontSize: 21),
              //             ),
              //           ),
              //           // FutureBuilder<String>(
              //           //   future: getTimeUntilNextParticipation(),
              //           //   builder: (context, snapshot) {
              //           //     if (snapshot.hasData) {
              //           //       return Text(snapshot.data!);
              //           //     } else {
              //           //       return SizedBox.shrink();
              //           //     }
              //           //   },
              //           // ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                "Calculateurs digitaux",
                style: TextStyle(fontSize: 26),
              )),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment
                    .centerLeft, // Aligns the container to the left side
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
                      bottomRight: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      children: [
                        Image.asset("assets/images/s.png"),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Aligns content to the left
                          children: [
                            Text(
                              "profitent de l'utilisation de  \n plusieurs calculateurs",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Get.to(CalculatorScreen());
                                },
                                child: Text("Suivant")),
                          ],
                        ),
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
                                      await Get.to(ListQuizScreenPro());
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
                  itemCount: allCategorieNews!.length,
                  itemBuilder: (context, index) {
                    final categorie = allCategorieNews![index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 2, left: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(
                            () {
                              selcted = categorie!.categorienewsnom!.toString();
                              if (selcted == allCategorieNews![0]) {
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
                                allCategorieNews![index].categorienewsnom!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selcted ==
                                          allCategorieNews![index]
                                              .categorienewsnom!
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Get.to(const ChatBot());
        //   },
        //   child: Image.asset(
        //     'assets/images/Group.png',
        //     height: 30,
        //   ),
        // ),
    );
  }
}
