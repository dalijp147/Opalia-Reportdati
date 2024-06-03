import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/categories.dart';
import '../../widegts/Allappwidgets/AppbarWidegts.dart';
import '../../widegts/Allappwidgets/Drawerwidgets.dart';
import '../chatbot/GemniScreen.dart';
import '../medicament/ProductCategorie.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categorie>? allcategorie = [];
  // Future<void> _fetchCategorie() async {
  //   try {
  //     final categories = await ApiService.getAllCategory();
  //     setState(() {
  //       allcategorie = categories;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch categorie: $e');
  //   }
  // }

  List<Categorie>? found = [];
  @override
  void initState() {
    super.initState();
    //_fetchCategorie();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url =
        Uri.parse("https://www.opaliarecordati.com/fr/produits/medical");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('div.bloc_left.left > ul > li > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    print('count ${titles.length}');
    setState(() {
      allcategorie = List.generate(
          titles.length, (index) => Categorie(categorienom: titles[index]));
    });
  }

  void _runfilter(String enterdKeyword) {
    List<Categorie>? results = [];
    if (enterdKeyword.isEmpty) {
      getWebsiteData();
    } else {
      results = allcategorie!
          .where((user) => user.categorienom!
              .toLowerCase()
              .contains(enterdKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      allcategorie = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppbarWidgets(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => _runfilter(value),
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxWidth: 350),
                  labelText: 'Recherche',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(50.0)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(
                  Icons.medication,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Classe Terapetique',
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
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: Colors.red),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Medical',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: Colors.red),
                    color: Colors.white),
                child: Center(
                  child: Text(
                    'Santé Familiale',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          allcategorie!.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                      padding:
                          const EdgeInsets.all(8.0), // padding around the grid
                      itemCount: allcategorie!.length, // total number of items
                      itemBuilder: (context, index) {
                        final categorie = allcategorie![index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductCategorieScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 2, color: Colors.red),
                                color: Colors.white), // color of grid items
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categorie.categorienom!,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // FutureBuilder<List<Categorie>?>(
                    //   future: ApiService.getAllCategory(),
                    //   builder: (BuildContext context,
                    //       AsyncSnapshot<List<Categorie>?> model) {
                    //     if (model.connectionState == ConnectionState.waiting) {
                    //       return Center(
                    //         child: Lottie.asset('assets/animation/heartrate.json',
                    //             height: 210, width: 210),
                    //       );
                    //     } else if (model.hasError) {
                    //       return Text('Error: ${model.error}');
                    //     } else {
                    //       return allcategorie!.isNotEmpty
                    //           ? GridView.builder(
                    //               gridDelegate:
                    //                   const SliverGridDelegateWithFixedCrossAxisCount(
                    //                 crossAxisCount: 3, // number of items in each row
                    //                 mainAxisSpacing: 8.0, // spacing between rows
                    //                 crossAxisSpacing: 8.0, // spacing between columns
                    //               ),
                    //               padding: const EdgeInsets.all(
                    //                   8.0), // padding around the grid
                    //               itemCount:
                    //                   allcategorie!.length, // total number of items
                    //               itemBuilder: (context, index) {
                    //                 final categorie = allcategorie![index];
                    //                 return GestureDetector(
                    //                   onTap: () {
                    //                     Get.to(ProductCategorieScreen(
                    //                         name: categorie.id!));
                    //                   },
                    //                   child: CategorieItem(
                    //                     model: categorie,
                    //                   ),
                    //                 );
                    //               },
                    //             )
                    //           : Center(
                    //               child: const Text(
                    //                 'pas de categorie trouvé  raffréchire pour retourné',
                    //                 style: TextStyle(fontSize: 15, color: Colors.red),
                    //               ),
                    //             );
                    //     }
                    //   },
                    // ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(ChatBot());
        },
        child: Icon(
          Icons.chat,
        ),
      ),
    );
  }
}
