import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import '../../../../models/categories.dart';

import '../../../../models/mediacment.dart';
import '../../widgets/Allappwidgets/AppbarWidegts.dart';
import '../../widgets/Allappwidgets/Drawerwidgets.dart';
import '../chatbot/GemniScreen.dart';
import '../medicament/DetailScreen.dart';
import '../medicament/ProductCategorie.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import '../../../../services/remote/apiService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categorie>? allcategorie = [];
  List<Categorie>? allSante = [];
  List<Medicament>? allMedicament = [];
  Future<void> _fetchMedicament() async {
    try {
      final medicament = await ApiService.getAllMedicament();
      setState(() {
        allMedicament = medicament;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  Future<void> _fetchCategorie() async {
    try {
      final categories = await ApiService.getAllCategory();
      setState(() {
        allcategorie = categories;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  List<Categorie>? found = [];
  @override
  void initState() {
    super.initState();
    _fetchCategorie();
    _fetchMedicament();
    //getWebsiteData();
  }

  // Future getWebsiteData() async {
  //   final urll =
  //       Uri.parse("https://www.opaliarecordati.com/fr/produits/paramedical");

  //   final responseSante = await http.get(urll);

  //   dom.Document htmls = dom.Document.html(responseSante.body);

  //   final titlesante = htmls
  //       .querySelectorAll('div.bloc_left.left > ul > li > a')
  //       .map((e) => e.innerHtml.trim())
  //       .toList();
  //   print('count ${titlesante.length}');

  //   setState(() {
  //     allSante = List.generate(
  //       titlesante.length,
  //       (index) => Categorie(
  //         categorienom: titlesante[index],
  //       ),
  //     );
  //   });
  // }

  void _runfilter(String enterdKeyword) {
    List<Categorie>? results = [];
    if (enterdKeyword.isEmpty) {
      _fetchCategorie();
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

  final TextEditingController _controller = TextEditingController();
  String selcted = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppbarWidgets(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: TextField(
          //       onChanged: (value) => _runfilter(value),
          //       decoration: InputDecoration(
          //         constraints: BoxConstraints(maxWidth: 350),
          //         labelText: 'Recherche',
          //         border: OutlineInputBorder(
          //             borderSide: BorderSide(
          //               color: Colors.red,
          //               width: 1,
          //             ),
          //             borderRadius: BorderRadius.circular(50.0)),
          //         prefixIcon: Icon(Icons.search),
          //       ),
          //     ),
          //   ),
          // ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: 300),
                    labelText: 'Recherche',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return allMedicament!
                      .where((user) => user.mediname!
                          .toLowerCase()
                          .contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.mediname!),
                    leading: Image.network(
                      (suggestion.mediImage == null ||
                              suggestion.mediImage!.isEmpty)
                          ? "https://fastly.picsum.photos/id/9/250/250.jpg?hmac=tqDH5wEWHDN76mBIWEPzg1in6egMl49qZeguSaH9_VI"
                          : suggestion.mediImage!,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object error,
                          StackTrace? stackTrace) {
                        // You can add logging here to see what the error is
                        print('Error loading image: $error');
                        return Image.network(
                          "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                        );
                      },
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // Handle when a suggestion is selected.
                  _controller.text = suggestion.mediname!;
                  Get.to(
                    DetailProduct(
                        image: suggestion.mediImage!,
                        title: suggestion.mediname!),
                  );
                  print(suggestion.mediname!);
                },
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
                  'Santé familiale',
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
            height: 5,
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
                            Get.to(ProductCategorieScreen(
                              name: categorie.id!,
                            ));
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
