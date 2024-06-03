import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/mediacment.dart';

import '../../../bloc/product/product_bloc.dart';
import '../../../services/remote/apiService.dart';
import 'DetailScreen.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

class ProductCategorieScreen extends StatefulWidget {
  //final String name;
  const ProductCategorieScreen({
    super.key,
    //required this.name,
  });

  @override
  State<ProductCategorieScreen> createState() => _ProductCategorieScreenState();
}

class _ProductCategorieScreenState extends State<ProductCategorieScreen> {
  final ProductBloc productBloc = ProductBloc();
  List<Medicament>? allMedicament = [];
  // Future<void> _fetchMedicament() async {
  //   try {
  //     final medicament = await ApiService.getMedicamentBycategorie(widget.name);
  //     setState(() {
  //       allMedicament = medicament;
  //     });
  //   } catch (e) {
  //     print('Failed to fetch categorie: $e');
  //   }
  // }

  Future getWebsiteData() async {
    final url = Uri.parse(
        "https://www.opaliarecordati.com/fr/produits/medical/specialite/62-dermatologie");
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    final titles = html
        .querySelectorAll('a > div.cat_titre')
        .map((e) => e.innerHtml.trim())
        .toList();
    final images = html
        .querySelectorAll('div.image_cat > img')
        .map((e) => e.attributes['src'])
        .toList();
    print('count ${titles.length}');
    setState(() {
      allMedicament = List.generate(
        titles.length,
        (index) =>
            Medicament(mediname: titles[index], mediImage: images[index]),
      );
    });
  }

  @override
  void initState() {
    // productBloc.add(CategorieMedicamentInitialFetchEvent(widget.name));
    //ApiService.getMedicamentBycategorie(widget.name);
    //print(widget.name);
    //_fetchMedicament();
    getWebsiteData();
    super.initState();
  }

  void _runfilter(String enterdKeyword) {
    List<Medicament>? results = [];
    if (enterdKeyword.isEmpty) {
      // _fetchMedicament();
      getWebsiteData();
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
            'Medicament',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (value) => _runfilter(value),
              decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: 300),
                labelText: 'Recherche',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(50.0)),
                prefixIcon: Icon(Icons.search),
              ),
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
                                final categorie = allMedicament![index];
                                return GestureDetector(
                                  onTap: () {
                                    //Get.to(DetailProduct(medi: categorie));
                                    Get.to(DetailProduct(
                                      image: categorie.mediImage!,
                                      title: categorie.mediname!,
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
                                            // categorie.categorieImage!,
                                            // height: 50,
                                            // width: 50,
                                            (categorie.mediImage == null ||
                                                    categorie.mediImage == "")
                                                ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                                                : categorie.mediImage!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.scaleDown,
                                          ),
                                          Text(
                                            categorie.mediname!,
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
