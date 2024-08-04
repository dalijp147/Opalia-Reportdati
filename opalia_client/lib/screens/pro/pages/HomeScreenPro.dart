import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/models/categorieNews.dart';
import 'package:opalia_client/screens/client/pages/quiz/SpinScreen.dart';
import 'package:opalia_client/screens/pro/widgets/quiz/ListQuizPro.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../bloc/news/bloc/news_bloc.dart';
import '../../../models/news.dart';
import '../../../services/local/sharedprefutils.dart';
import '../../../services/remote/apiService.dart';

import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../../client/pages/chatbot/GemniScreen.dart';
import '../../client/widgets/News/NewsList.dart';
import '../../client/widgets/quiz/ListQuiz.dart';
import '../widgets/Reusiblewidgets/AppBarWidgetPro.dart';
import '../widgets/Reusiblewidgets/Drawerwidgets.dart';

class HomeScreenAppPRo extends StatefulWidget {
  const HomeScreenAppPRo({super.key});

  @override
  State<HomeScreenAppPRo> createState() => _HomeScreenAppPRoState();
}

class _HomeScreenAppPRoState extends State<HomeScreenAppPRo> {
  bool verif = false;
  List<News>? allNews = [];

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

  Future<bool> verify() async {
    final x = await ApiService.getResultdoctorId(PreferenceUtils.getuserid());
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
      drawer: DrawerWidgetPro(),
      appBar: AppBarWidget(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
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
                        height: 150,
                        filterQuality: FilterQuality.high,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: verif
                              ? ElevatedButton.styleFrom(
                                  fixedSize: Size(360, 50))
                              : ElevatedButton.styleFrom(
                                  fixedSize: Size(250, 20)),
                          onPressed: verif
                              ? null
                              : () {
                                  Get.to(ListQuizScreenPro());
                                },
                          child: verif
                              ? Text('Tu as déjà participé au quiz',
                                  style: TextStyle(fontSize: 20))
                              : Text('Jouez au quiz',
                                  style: TextStyle(fontSize: 25))),
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
