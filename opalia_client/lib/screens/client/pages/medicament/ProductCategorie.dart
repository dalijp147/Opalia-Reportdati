import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/mediacment.dart';

import '../../../../bloc/product/product_bloc.dart';
import '../../../../services/remote/apiService.dart';
import 'DetailScreen.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class ProductCategorieScreen extends StatefulWidget {
  final String name;
  final String title;
  const ProductCategorieScreen({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  State<ProductCategorieScreen> createState() => _ProductCategorieScreenState();
}

class _ProductCategorieScreenState extends State<ProductCategorieScreen> {
  final ProductBloc productBloc = ProductBloc();
  List<Medicament>? allMedicament = [];
  Future<void> _fetchMedicament() async {
    try {
      final medicament = await ApiService.getMedicamentBycategorie(widget.name);
      setState(() {
        allMedicament = medicament;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  @override
  void initState() {
    productBloc.add(CategorieMedicamentInitialFetchEvent(widget.name));
    ApiService.getMedicamentBycategorie(widget.name);

    //print(widget.name);
    _fetchMedicament();
    //getWebsiteData();
    super.initState();
  }

  void _runfilter(String enterdKeyword) {
    List<Medicament>? results = [];
    if (enterdKeyword.isEmpty) {
      // _fetchMedicament();
      _fetchMedicament();
    } else {
      results = allMedicament!
          .where((user) => user.mediname!
              .toLowerCase()
              .contains(enterdKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      allMedicament = results;
    });
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    stops: [1, 0.1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.red.shade50, Colors.white])),
          ),
          title: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/Grouhome.png'), // Replace with your image path
              fit: BoxFit.cover, // Adjust the image to cover the entire screen
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              // TextField(
              //   onChanged: (value) => _runfilter(value),
              //   decoration: InputDecoration(
              //     constraints: BoxConstraints(maxWidth: 300),
              //     labelText: 'Recherche',
              //     border: OutlineInputBorder(
              //         borderSide: BorderSide(color: Colors.red, width: 1),
              //         borderRadius: BorderRadius.circular(50.0)),
              //     prefixIcon: Icon(Icons.search),
              //   ),
              // ),
              TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  autofocus: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(maxWidth: 300),
                    labelText: 'Recherche',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(50.0)),
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
                  );
                },
                onSuggestionSelected: (suggestion) {
                  // Handle when a suggestion is selected.
                  _controller.text = suggestion.mediname!;
                  Get.to(
                    DetailProduct(
                      image: suggestion.mediImage!,
                      title: suggestion.mediname!,
                      classeparamedicalemedi:
                          suggestion.classeparamedicalemedi!,
                      dci: suggestion.dci!,
                      forme: suggestion.forme!,
                      presentationmedi: suggestion.presentationmedi!,
                      sousclasse: suggestion.sousclassemedi!,
                    ),
                  );
                  print(suggestion.mediname!);
                },
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: FutureBuilder<List<Medicament>>(
                  //future: ApiService.getMedicamentBycategorie(widget.name),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Medicament>> model) {
                    if (model.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (model.hasError) {
                      return Text('Error: ${model.error}');
                    } else {
                      return allMedicament!.isNotEmpty
                          ? Container(
                              height: double.infinity,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            2, // number of items in each row
                                        mainAxisSpacing:
                                            8.0, // spacing between rows
                                        crossAxisSpacing: 8.0,
                                        childAspectRatio: 0.8
                                        // spacing between columns
                                        ),
                                padding: const EdgeInsets.all(
                                    8.0), // padding around the grid
                                itemCount: allMedicament!
                                    .length, // total number of items
                                itemBuilder: (context, index) {
                                  final categorie = allMedicament![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(DetailProduct(
                                        image: categorie.mediImage!,
                                        title: categorie.mediname!,
                                        classeparamedicalemedi:
                                            categorie.classeparamedicalemedi!,
                                        dci: categorie.dci!,
                                        forme: categorie.forme!,
                                        presentationmedi:
                                            categorie.presentationmedi!,
                                        sousclasse: categorie.sousclassemedi!,
                                      ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              width: 2, color: Colors.red),
                                          color: Colors
                                              .white), // color of grid items
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromRGBO(250, 239, 239, 1),
                                              Color.fromRGBO(255, 255, 255, 1),
                                            ], // Gradient colors when selected
                                            // Gradient colors when not selected
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Container(
                                                    height: 100,
                                                    width: 150,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                (categorie.mediImage == null ||
                                                        categorie.mediImage ==
                                                            "")
                                                    ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                                                    : categorie.mediImage!,
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.scaleDown,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object error,
                                                    StackTrace? stackTrace) {
                                                  // You can add logging here to see what the error is
                                                  print(
                                                      'Error loading image: $error');
                                                  return Image.network(
                                                    height: 150,
                                                    width: 100,
                                                    "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  categorie.mediname!,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: const Text(
                                'pas de resultats',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.red),
                              ),
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
