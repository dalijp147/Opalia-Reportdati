import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:opalia_client/services/apiService.dart';
import 'package:opalia_client/widegts/BottomNav.dart';

import '../../models/categories.dart';
import '../../widegts/Categorie/CategorieItem.dart';
import 'medicament/ProductCategorie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  List<Categorie> data = [];
  List<Categorie> searchResults = [];
  //  void onQueryChanged(String newQuery) {
  //    setState(() {
  //      searchResults = data.where((item) => item.contains(query)).toList();
  //  });
  // }

  @override
  void initState() {
    ApiService.getAllCategory();
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
                  colors: [Colors.red.shade50, Colors.white])),
        ),
        leading: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
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
                // onChanged: onQueryChanged,
                decoration: InputDecoration(
                  constraints: BoxConstraints(maxWidth: 350),
                  labelText: 'Search',
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
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // number of items in each row
                        mainAxisSpacing: 8.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                      padding:
                          const EdgeInsets.all(8.0), // padding around the grid
                      itemCount: model.data!.length, // total number of items
                      itemBuilder: (context, index) {
                        final categorie = model.data![index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductCategorieScreen(name: categorie.id!));
                          },
                          child: CategorieItem(
                            model: categorie,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
