import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:opalia_client/services/apiService.dart';

import '../../../bloc/product/product_bloc.dart';
import 'DetailScreen.dart';

class ProductCategorieScreen extends StatefulWidget {
  final String name;
  const ProductCategorieScreen({super.key, required this.name});

  @override
  State<ProductCategorieScreen> createState() => _ProductCategorieScreenState();
}

class _ProductCategorieScreenState extends State<ProductCategorieScreen> {
  final ProductBloc productBloc = ProductBloc();

  @override
  void initState() {
    // productBloc.add(CategorieMedicamentInitialFetchEvent(widget.name));
    ApiService.getMedicamentBycategorie(widget.name);
    print(widget.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<List<Medicament>>(
          future: ApiService.getMedicamentBycategorie(widget.name),
          builder:
              (BuildContext context, AsyncSnapshot<List<Medicament>> model) {
            if (model.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (model.hasError) {
              return Text('Error: ${model.error}');
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 8.0, // spacing between rows
                  crossAxisSpacing: 8.0, // spacing between columns
                ),
                padding: const EdgeInsets.all(8.0), // padding around the grid
                itemCount: model.data!.length, // total number of items
                itemBuilder: (context, index) {
                  final categorie = model.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(DetailProduct(medi: categorie));
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
                              categorie.mediname!,
                              style: TextStyle(fontSize: 15, color: Colors.red),
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
    );
  }
}
