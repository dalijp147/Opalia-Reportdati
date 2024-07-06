import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../models/categoriePro.dart';
import '../../../../models/mediacment.dart';
import '../../../../services/remote/apiService.dart';
import '../../../client/pages/chatbot/GemniScreen.dart';
import '../../widgets/Reusiblewidgets/AppBarWidgetPro.dart';
import '../../widgets/Reusiblewidgets/Drawerwidgets.dart';
import '../Médicament/ProductCategoriePro.dart';

class CategorieProScreen extends StatefulWidget {
  const CategorieProScreen({super.key});

  @override
  State<CategorieProScreen> createState() => _CategorieProScreenState();
}

class _CategorieProScreenState extends State<CategorieProScreen> {
  List<CategoriePro>? allCategoriePro = [];
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
      final categories = await ApiServicePro.getAllCategoryPro();
      setState(() {
        allCategoriePro = categories;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  @override
  void initState() {
    _fetchCategorie();
    _fetchMedicament();
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidgetPro(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  // Get.to(
                  //   DetailProduct(
                  //       image: suggestion.mediImage!,
                  //       title: suggestion.mediname!),
                  // );
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
                  Icons.medical_services_rounded,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Médicament',
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
          allCategoriePro!.isEmpty
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
                      itemCount:
                          allCategoriePro!.length, // total number of items
                      itemBuilder: (context, index) {
                        final categorie = allCategoriePro![index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(ProductCategorieProScreen(
                              title: categorie.categorienompro! ,
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
                                    categorie.categorienompro!,
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
