import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/mediacment.dart';

import '../../../../bloc/product/product_bloc.dart';
import '../../../../services/remote/apiService.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../widgets/Reusiblewidgets/Drawerwidgets.dart';
import 'DetailMedicamentScreen.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class ProductCategorieProScreen extends StatefulWidget {
  final String name;
  final String title;

  const ProductCategorieProScreen({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  State<ProductCategorieProScreen> createState() =>
      _ProductCategorieProScreenState();
}

class _ProductCategorieProScreenState extends State<ProductCategorieProScreen> {
  final ProductBloc productBloc = ProductBloc();
  List<Medicament>? allMedicament = [];
  Future<void> _fetchMedicament() async {
    try {
      final medicament =
          await ApiServicePro.getMedicamentBycategoriePro(widget.name);
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
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
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
                  DetailMedicamentPro(
                    image: suggestion.mediImage!,
                    title: suggestion.mediname!,
                    sousclasse: suggestion.sousclassemedi!,
                    id: suggestion.mediId!,
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
                                mainAxisSpacing: 8.0, // spacing between rows
                                crossAxisSpacing: 8.0,
                                // spacing between columns
                              ),
                              padding: const EdgeInsets.all(
                                  8.0), // padding around the grid
                              itemCount: allMedicament!
                                  .length, // total number of items
                              itemBuilder: (context, index) {
                                final medicament = allMedicament![index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(DetailMedicamentPro(
                                      image: medicament.mediImage!,
                                      title: medicament.mediname!,
                                      sousclasse: medicament.sousclassemedi!,
                                      id: medicament.mediId!,
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 2, color: Colors.red),
                                        color: Colors
                                            .white), // color of grid items
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
                                            (medicament.mediImage == null ||
                                                    medicament.mediImage == "")
                                                ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                                                : medicament.mediImage!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.scaleDown,
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              // You can add logging here to see what the error is
                                              print(
                                                  'Error loading image: $error');
                                              return Image.network(
                                                height: 100,
                                                width: 100,
                                                "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                              );
                                            },
                                          ),
                                          Text(
                                            medicament.mediname!,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red),
                                          ),
                                        ],
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
                              style: TextStyle(fontSize: 15, color: Colors.red),
                            ),
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
