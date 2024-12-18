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
  final String forme;
  final String dci;
  final String presentationmedi;
  final String classeparamedicalemedi;
  final String tit;
  DetailMedicamentPro({
    super.key,
    required this.image,
    required this.title,
    required this.sousclasse,
    required this.id,
    required this.tit,
    required this.forme,
    required this.classeparamedicalemedi,
    required this.presentationmedi,
    required this.dci,
  });

  @override
  State<DetailMedicamentPro> createState() => _DetailMedicamentProState();
}

class _DetailMedicamentProState extends State<DetailMedicamentPro> {
  List<Medicament>? allMedicament = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(182, 28, 12, 0.1),
                    Color.fromRGBO(255, 255, 255, 0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  (widget.image == null || widget.image == "")
                      ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                      : widget.image!,
                  fit: BoxFit.cover,
                ),
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
                        child: Column(
                      children: [
                        Icon(Icons.medication, color: Colors.red, size: 30),
                        Text(
                          'Présentation',
                          style: TextStyle(
                            color: Color.fromARGB(255, 254, 17, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.presentationmedi,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Column(
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
                        Text(
                          widget.dci,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        Text(
                          'unknown',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        child: Column(
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
                          widget.forme,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        Icon(Icons.health_and_safety_outlined,
                            color: Colors.red, size: 30),
                        Text(
                          'Classe thérapeutique',
                          style: TextStyle(
                              color: Color.fromARGB(255, 254, 17, 0),
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        Text(
                          widget.classeparamedicalemedi!,
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
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                              ),
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
                  future: ApiServicePro.getMedicamentBycategoriePro(widget.tit),
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
                                    cat: widget.tit,
                                  );
                                },
                              ),
                            );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
