import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/screens/pages/menu/MenuScreen.dart';
import 'package:opalia_client/screens/pages/menu/SettingsScreen.dart';

import 'package:opalia_client/services/apiService.dart';
import 'package:opalia_client/widegts/BottomNav.dart';

import '../../models/categories.dart';
import '../../widegts/Categorie/CategorieItem.dart';
import 'chatbot/GemniScreen.dart';
import 'medicament/ProductCategorie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Categorie>? allcategorie = [];
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
    _fetchCategorie();

    super.initState();
  }

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
                      borderSide: BorderSide(color: Colors.red, width: 1)),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          const Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'CLASSES THÉRAPEUTIQUES',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Categorie>?>(
                future: ApiService.getAllCategory(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Categorie>?> model) {
                  if (model.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset('assets/animation/heartrate.json',
                          height: 210, width: 210),
                    );
                  } else if (model.hasError) {
                    return Text('Error: ${model.error}');
                  } else {
                    return allcategorie!.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // number of items in each row
                              mainAxisSpacing: 8.0, // spacing between rows
                              crossAxisSpacing: 8.0, // spacing between columns
                            ),
                            padding: const EdgeInsets.all(
                                8.0), // padding around the grid
                            itemCount:
                                allcategorie!.length, // total number of items
                            itemBuilder: (context, index) {
                              final categorie = allcategorie![index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ProductCategorieScreen(
                                      name: categorie.id!));
                                },
                                child: CategorieItem(
                                  model: categorie,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: const Text(
                              'pas de categorie trouvé  raffréchire pour retourné',
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                          );
                  }
                },
              ),
            ),
          )
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
