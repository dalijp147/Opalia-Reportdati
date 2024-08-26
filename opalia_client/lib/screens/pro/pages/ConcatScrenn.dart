import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contactez-Nous',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
        centerTitle: true,
      ),
      body: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Siège commercial :\n27, Avenue de la Livre Sterling, les Berges du Lac 2 - 1053 Tunis',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 10),
            Text(
              'Tel : (+216) 71 19 63 57 / Fax : (+216) 71 19 63 59',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'Site de production :\nZ.I. Kalaat Al Andalouss – 2022 Ariana',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 10),
            Text(
              'Tel : (+216) 70 55 90 70 / (+216) 70 55 90 64 / Fax : (+216) 70 55 91 84',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              'E-mail : contact@opaliarecordati.com',
              style: TextStyle(fontSize: 16, height: 1.5, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
