import 'package:flutter/material.dart';

class RelatedMedicamentProDetail extends StatelessWidget {
  final String image;
  final String name;
  const RelatedMedicamentProDetail(
      {super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  image!.replaceFirst("file:///", "http://"),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
                  Text(
                    'unknown',
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
                  Icon(Icons.blur_circular_sharp, color: Colors.red, size: 30),
                  Text(
                    'DCI',
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
                    'unknown',
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
                    'unknown',
                    style:
                        TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
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
                        "unknown",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ]),
      ),
    );
  }
}
