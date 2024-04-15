import 'package:flutter/material.dart';
import 'package:opalia_client/models/categories.dart';

class CategorieItem extends StatefulWidget {
  final Categorie model;
  const CategorieItem({super.key, required this.model});

  @override
  State<CategorieItem> createState() => _CategorieItemState();
}

class _CategorieItemState extends State<CategorieItem> {
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
              // categorie.categorieImage!,
              // height: 50,
              // width: 50,
              (widget.model.categorieImage == null ||
                      widget.model.categorieImage == "")
                  ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                  : widget.model.categorieImage!,
              height: 60,
              width: 100,
              fit: BoxFit.scaleDown,
            ),
            Text(
              widget.model.categorienom!,
              style: TextStyle(fontSize: 15, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
