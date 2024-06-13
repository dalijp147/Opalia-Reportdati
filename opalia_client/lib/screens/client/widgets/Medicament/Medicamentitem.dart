import 'package:flutter/material.dart';
import 'package:opalia_client/models/mediacment.dart';

class MedicamentItem extends StatefulWidget {
  final Medicament model;
  const MedicamentItem({super.key, required this.model});

  @override
  State<MedicamentItem> createState() => _MedicamentItemState();
}

class _MedicamentItemState extends State<MedicamentItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2, color: Colors.red),
          color: Colors.white), // color of grid items
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.model.mediImage!.replaceFirst("file:///", "http://"),
              height: 1000,
              width: 100,
            ),
            Text(
              widget.model.mediname!,
              style: TextStyle(fontSize: 15, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
