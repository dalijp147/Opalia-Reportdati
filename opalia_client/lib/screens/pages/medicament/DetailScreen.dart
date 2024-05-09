import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/models/mediacment.dart';

class DetailProduct extends StatelessWidget {
  final Medicament medi;
  DetailProduct({super.key, required this.medi});

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
                colors: [Colors.red.shade50, Colors.white],
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.red),
              width: double.infinity,
              child: Image.network(
                // categorie.categorieImage!,
                // height: 50,
                // width: 50,
                (medi.mediImage == null || medi.mediImage == "")
                    ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                    : medi.mediImage!,
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
                  size: 20,
                  color: Colors.white,
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
                          width: 35,
                          color: Colors.black12,
                        )
                      ],
                    ),
                  ),
                  Text(
                    medi.mediname!,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    medi.medidesc!,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          child: const Column(
                        children: [
                          Icon(Icons.abc, color: Colors.red, size: 30),
                          Text('data'),
                          Text('Boite de 20'),
                        ],
                      )),
                      Container(
                          child: const Column(
                        children: [
                          Icon(Icons.abc, color: Colors.red, size: 30),
                          Text('data'),
                          Text('Boite de 20'),
                        ],
                      )),
                      Container(
                          child: const Column(
                        children: [
                          Icon(Icons.abc, color: Colors.red, size: 30),
                          Text('data'),
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
                          Icon(Icons.abc, color: Colors.red, size: 30),
                          Text('data'),
                          Text('Boite de 20'),
                        ],
                      )),
                      Container(
                          child: const Column(
                        children: [
                          Icon(Icons.abc, color: Colors.red, size: 30),
                          Text('data'),
                          Text('Boite de 20'),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
