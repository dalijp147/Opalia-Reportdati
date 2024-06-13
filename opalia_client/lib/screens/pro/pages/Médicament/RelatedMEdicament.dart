import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/pages/M%C3%A9dicament/DetailMedicamentScreen.dart';

class ReleatedMedicamentScreen extends StatefulWidget {
  final String name;
  final String image;
  final String id;
  final String souclasse;
  const ReleatedMedicamentScreen({
    super.key,
    required this.name,
    required this.image,
    required this.id,
    required this.souclasse,
  });

  @override
  State<ReleatedMedicamentScreen> createState() =>
      _ReleatedMedicamentScreenState();
}

class _ReleatedMedicamentScreenState extends State<ReleatedMedicamentScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailMedicamentPro(
          image: widget.image,
          title: widget.name,
          id: widget.id,
          sousclasse: widget.souclasse,
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
                  widget.image,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.name,
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
