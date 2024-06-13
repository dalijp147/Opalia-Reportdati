import 'dart:ui';
import 'package:opalia_client/screens/pro/pages/M%C3%A9dicament/RelatedMEdicament.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:opalia_client/models/mediacment.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../../../../services/remote/apiServicePro.dart';

class DetailMedicamentPro extends StatefulWidget {
  //final Medicament medi;
  final String id;
  final String image;
  final String title;
  final String sousclasse;
  DetailMedicamentPro({
    super.key,
    required this.image,
    required this.title,
    required this.sousclasse,
    required this.id,
    //required this.medi,
  });

  @override
  State<DetailMedicamentPro> createState() => _DetailMedicamentProState();
}

class _DetailMedicamentProState extends State<DetailMedicamentPro> {
  List<Medicament>? allMedicament = [];
  Future<void> _fetchMedicament() async {
    try {
      final medicament =
          await ApiServicePro.getMedicamentBycategoriePro(widget.id);
      setState(() {
        allMedicament = medicament;
      });
    } catch (e) {
      print('Failed to fetch categorie: $e');
    }
  }

  @override
  void initState() {
    _fetchMedicament();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              width: double.infinity,
              child:
                  // Image.network(
                  //   (medi.mediImage == null || medi.mediImage == "")
                  //       ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                  //       : medi.mediImage!,
                  // ),
                  Image.network(
                (widget.image == null || widget.image == "")
                    ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                    : widget.image!,
              ),
            ),
            buttonArrow(context),
            scroll(),
          ],
        ),
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 1.0,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 30,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
                // Text(
                //   medi.mediname!,
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                // ),
                Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Divider(height: 4),
                ),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text(
                //   medi.medidesc!,
                // ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: const Column(
                      children: [
                        Icon(Icons.medication, color: Colors.red, size: 30),
                        Text(
                          'Présentation',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Boite de 20'),
                      ],
                    )),
                    Container(
                        child: const Column(
                      children: [
                        Icon(Icons.blur_circular_sharp,
                            color: Colors.red, size: 30),
                        Text(
                          'DCI',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Boite de 20'),
                      ],
                    )),
                    Container(
                        child: const Column(
                      children: [
                        Icon(Icons.medication_liquid_sharp,
                            color: Colors.red, size: 30),
                        Text(
                          'Dosage',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Boite de 20'),
                      ],
                    )),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        child: const Column(
                      children: [
                        Icon(Icons.medical_services_outlined,
                            color: Colors.red, size: 30),
                        Text(
                          'Forme',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Boite de 20',
                        ),
                      ],
                    )),
                    Container(
                        child: const Column(
                      children: [
                        Icon(Icons.health_and_safety_outlined,
                            color: Colors.red, size: 30),
                        Text(
                          'Classe thérapeutique',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Boite de 20',
                          style: TextStyle(
                              fontSize: 10.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                    Container(
                        width: 100,
                        height: 100,
                        child: Column(
                          children: [
                            Icon(Icons.medical_information_outlined,
                                color: Colors.red, size: 30),
                            Text(
                              'Sous classe thérapeutique',
                              style: TextStyle(
                                color: Color.fromARGB(255, 254, 17, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.sousclasse,
                              style: TextStyle(
                                  fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                const Text(
                  "PRODUITS APPARENTÉS",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Medicament>>(
                  future: ApiServicePro.getMedicamentBycategoriePro(widget.id),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Medicament>> model) {
                    if (model.connectionState == ConnectionState.waiting) {
                      return Column(children: [
                        SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ]);
                    } else if (model.hasError) {
                      return Center(child: Text('Error: ${model.error}'));
                    } else {
                      return model.data!.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 100,
                                ),
                                Center(
                                  child: Text(
                                      'Pas de medicament pour cette categorie'),
                                ),
                              ],
                            )
                          : Container(
                              width: 500,
                              height: 250,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: model.data!.length,
                                itemBuilder: (context, index) {
                                  final news = model.data![index];
                                  return ReleatedMedicamentScreen(
                                    image: news.mediImage!,
                                    name: news.mediname!,
                                    id: news.mediId!,
                                    souclasse: news.sousclassemedi!,
                                  );
                                },
                              ),
                            );
                    }
                  },
                )
                // Container(
                //   width: 500,
                //   height: 250,
                //   child: ListView.builder(
                //     scrollDirection: Axis.horizontal,
                //     itemCount: allMedicament!.length,
                //     itemBuilder: (context, index) {
                //       final medicament = allMedicament![index];
                //       return GestureDetector(
                //         onTap: () {
                //           Get.to(DetailMedicamentPro(
                //             image: medicament.mediImage!,
                //             title: medicament.mediname!,
                //             sousclasse: medicament.sousclassemedi!,
                //             id: medicament.mediId!,
                //           ));
                //         },
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Container(
                //             width: 250,
                //             height: 200,
                //             decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(20),
                //               border: Border.all(width: 2, color: Colors.red),
                //               color: Colors.white,
                //             ),
                //             child: Center(
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Image.network(
                //                     loadingBuilder: (BuildContext context,
                //                         Widget child,
                //                         ImageChunkEvent? loadingProgress) {
                //                       if (loadingProgress == null) return child;
                //                       return Container(
                //                         height: 100,
                //                         width: 150,
                //                         child: Center(
                //                           child: CircularProgressIndicator(
                //                             value: loadingProgress
                //                                         .expectedTotalBytes !=
                //                                     null
                //                                 ? loadingProgress
                //                                         .cumulativeBytesLoaded /
                //                                     loadingProgress
                //                                         .expectedTotalBytes!
                //                                 : null,
                //                           ),
                //                         ),
                //                       );
                //                     },
                //                     // categorie.categorieImage!,
                //                     // height: 50,
                //                     // width: 50,
                //                     (medicament.mediImage == null ||
                //                             medicament.mediImage == "")
                //                         ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                //                         : medicament.mediImage!,
                //                     height: 100,
                //                     width: 100,
                //                     fit: BoxFit.scaleDown,
                //                     errorBuilder: (BuildContext context,
                //                         Object error, StackTrace? stackTrace) {
                //                       // You can add logging here to see what the error is
                //                       print('Error loading image: $error');
                //                       return Image.network(
                //                         "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                //                       );
                //                     },
                //                   ),
                //                   Text(
                //                     medicament.mediname!,
                //                     style: TextStyle(
                //                         fontSize: 12, color: Colors.red),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        );
      },
    );
  }
}
