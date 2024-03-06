import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pages/DetailScreen.dart';
import 'package:opalia_client/screens/pages/ProductScreen.dart';
import 'package:opalia_client/services/apiService.dart';
import 'package:opalia_client/widegts/BottomNav.dart';

import '../../models/categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              icon: Icon(
                Icons.person,
                color: Colors.red,
              ))
        ],
        title: Text(
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
          Padding(
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
                    return Center(child: CircularProgressIndicator());
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
                            Get.to(ProductScreen());
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
                                  // Image.network(
                                  //   // categorie.categorieImage!,
                                  //   // height: 50,
                                  //   // width: 50,
                                  //   (categorie.categorieImage == null ||
                                  //           categorie.categorieImage == "")
                                  //       ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                                  //       : categorie.categorieImage!,
                                  //   height: 100,
                                  //   width: 100,
                                  //   fit: BoxFit.scaleDown,
                                  // ),
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
