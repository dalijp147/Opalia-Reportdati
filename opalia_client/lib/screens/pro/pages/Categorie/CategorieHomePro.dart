import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/client/pages/medicament/ProductCategorie.dart';
import 'package:opalia_client/screens/pro/pages/M%C3%A9dicament/DetailMedicamentScreen.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../models/categoriePro.dart';
import '../../../../models/categories.dart';
import '../../../../models/mediacment.dart';
import '../../../../services/remote/apiService.dart';
import '../../../client/pages/chatbot/GemniScreen.dart';
import '../../widgets/Allappwidgets/AppBarWidgetPro.dart';
import '../../widgets/Allappwidgets/Drawerwidgets.dart';
import '../Médicament/ProductCategoriePro.dart';

class CategorieProScreen extends StatefulWidget {
  const CategorieProScreen({super.key});

  @override
  State<CategorieProScreen> createState() => _CategorieProScreenState();
}

class _CategorieProScreenState extends State<CategorieProScreen> {
  List<CategoriePro>? allCategoriePro = [];
  List<Medicament>? allMedicament = [];
  List<Categorie>? allcategorie = [];
  bool isCategorieProSelected = true;

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

  Future<void> _fetchCategoriePatient() async {
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
    _fetchCategoriePatient();
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidgetPro(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/Grouhome.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the image to cover the entire screen
          ),
        ),
        child: Column(
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
                      constraints:
                          BoxConstraints(maxWidth: 300, minHeight: 100),
                      labelText: 'Que cherchez-vous',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1),
                        borderRadius: BorderRadius.circular(20.0),
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
                      DetailMedicamentPro(
                        forme: suggestion.forme!,
                        image: suggestion.mediImage!,
                        title: suggestion.mediname!,
                        id: suggestion.mediId!,
                        sousclasse: suggestion.sousclassemedi!,
                        tit: suggestion.mediId!,
                        classeparamedicalemedi:
                            suggestion.classeparamedicalemedi!,
                        dci: suggestion.dci!,
                        presentationmedi: suggestion.presentationmedi!,
                      ),
                    );
                    print(suggestion.mediname!);
                  },
                ),
              ),
            ),

            SizedBox(
              height: 5,
            ),
            // The new container with two texts
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 70,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 235, 235, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                          ], // Gradient colors when selected
                          // Gradient colors when not selected
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isCategorieProSelected = false;
                          });
                        },
                        child: Center(
                          child: Text(
                            'Santé familiale',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCategorieProSelected
                                    ? Colors.grey
                                    : Colors.red,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // 'Santé familiale',
                      height: 70,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 235, 235, 1),
                            Color.fromRGBO(255, 255, 255, 1),
                          ], // Gradient colors when selected
                          // Gradient colors when not selected
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isCategorieProSelected = true;
                          });
                        },
                        child: Center(
                          child: Text(
                            'Médicament',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCategorieProSelected
                                    ? Colors.red
                                    : Colors.grey,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // number of items in each row
                    mainAxisSpacing: 8.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),
                  padding: const EdgeInsets.all(8.0), // padding around the grid
                  itemCount: isCategorieProSelected
                      ? allCategoriePro!.length
                      : allcategorie!.length, // total number of items
                  itemBuilder: (context, index) {
                    final categorie = isCategorieProSelected
                        ? allCategoriePro![index]
                        : allcategorie![index];
                    return GestureDetector(
                      onTap: () {
                        if (isCategorieProSelected) {
                          Get.to(ProductCategorieProScreen(
                            title: allCategoriePro![index].categorienompro!,
                            name: allCategoriePro![index].id!,
                          ));
                        } else {
                          // Navigate to the Categorie screen when selected
                          Get.to(ProductCategorieScreen(
                            name: allcategorie![index].id!,
                            title: allcategorie![index].categorienom!,
                          ));
                        }
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
                                isCategorieProSelected
                                    ? allCategoriePro![index].categorienompro!
                                    : allcategorie![index].categorienom!,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
