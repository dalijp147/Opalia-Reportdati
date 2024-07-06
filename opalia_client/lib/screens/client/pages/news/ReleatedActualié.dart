import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../medicament/DetailScreen.dart';
import 'RelatedNewsDeatil.dart';

class RelatedActualieItem extends StatefulWidget {
  final String nameNews;
  final String imageNews;
  final String desc;
  const RelatedActualieItem(
      {super.key,
      required this.nameNews,
      required this.imageNews,
      required this.desc});

  @override
  State<RelatedActualieItem> createState() => _RelatedActualieItemState();
}

class _RelatedActualieItemState extends State<RelatedActualieItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DatailRelatednews(
          image: widget.imageNews,
          name: widget.nameNews,
          description: widget.desc,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 250,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.red),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.imageNews,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.nameNews,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
