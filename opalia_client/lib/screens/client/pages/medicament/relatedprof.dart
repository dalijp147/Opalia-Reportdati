import 'package:flutter/material.dart';

class RelatedScreen extends StatelessWidget {
  const RelatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      // Get.to(DetailProduct(
      //   image: medicament.mediImage!,
      //   title: medicament.mediname!,
      // ));

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 2, color: Colors.red),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.network(
                //   // categorie.categorieImage!,
                //   // height: 50,
                //   // width: 50,
                //   (medicament.mediImage == null || medicament.mediImage == "")
                //       ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                //       : medicament.mediImage!,
                //   height: 100,
                //   width: 100,
                //   fit: BoxFit.scaleDown,
                // ),
                // Text(
                //   medicament.mediname!,
                //   style: TextStyle(fontSize: 12, color: Colors.red),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
