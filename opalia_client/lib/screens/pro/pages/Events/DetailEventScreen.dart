import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/events.dart';

class DetailEventScreen extends StatefulWidget {
  final Events event;
  const DetailEventScreen({super.key, required this.event});

  @override
  State<DetailEventScreen> createState() => _DetailEventScreenState();
}

class _DetailEventScreenState extends State<DetailEventScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
          title: Text('Evenement Détail'),
          centerTitle: true,
          // bottom:
        ),
        body: Column(
          children: [
            TabBar(
              tabs: [
                Tab(
                  text: "detaille",
                ),
                Tab(
                  text: "Programme",
                ),
                Tab(
                  text: "discussion",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      width: double.infinity,
                      child: Image.network(
                        (widget.event.eventimage == null ||
                                widget.event.eventimage == "")
                            ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
                            : widget.event.eventimage!,
                      ),
                    ),
                    Text(
                      widget.event.eventname!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(height: 4),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ),
                        Text(widget.event.eventname!),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.red,
                        ),
                        Text(widget.event.dateEvent!.toString()),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Description :",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.event.eventdescription!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: Text(
                          'Inscription',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                ListView(children: [Text('data')]),
                Icon(Icons.abc),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
//  SafeArea(
//   child: Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(color: Colors.white),
//             width: double.infinity,
//             child:
//                 // Image.network(
//                 //   (medi.mediImage == null || medi.mediImage == "")
//                 //       ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
//                 //       : medi.mediImage!,
//                 // ),
//                 Image.network(
//               (widget.event.eventimage == null ||
//                       widget.event.eventimage == "")
//                   ? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpngtree.com%2Fso%2Fno-internet-connection&psig=AOvVaw2HCMMO6ShxWOr8l3PHFJge&ust=1709807202871000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCPihjZbE34QDFQAAAAAdAAAAABAE"
//                   : widget.event.eventimage!,
//             ),
//           ),

//           // buttonArrow(context),
//           // scroll(),
//         ],
//       ),
//     ),
//   );
// }

// buttonArrow(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: InkWell(
//       onTap: () {},
//       child: Container(
//         clipBehavior: Clip.hardEdge,
//         height: 55,
//         width: 55,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             height: 55,
//             width: 55,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: const Icon(
//                 Icons.arrow_back,
//                 size: 30,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// scroll() {
//   return DraggableScrollableSheet(
//     initialChildSize: 0.6,
//     maxChildSize: 1.0,
//     minChildSize: 0.6,
//     builder: (context, scrollController) {
//       return Container(
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         clipBehavior: Clip.hardEdge,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: SingleChildScrollView(
//           controller: scrollController,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, bottom: 25),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 5,
//                       width: 30,
//                       color: Colors.black12,
//                     )
//                   ],
//                 ),
//               ),
//               // Text(
//               //   medi.mediname!,
//               //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               // ),
//               Text(
//                 widget.event.eventname!,
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 15),
//                 child: Divider(height: 4),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                   ),
//                   Text(widget.event.eventname!),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.date_range,
//                     color: Colors.red,
//                   ),
//                   Text(widget.event.dateEvent!.toString()),
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               const Text(
//                 "Description :",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 widget.event.eventdescription!,
//                 style: TextStyle(
//                   fontWeight: FontWeight.normal,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Align(
//                 alignment: FractionalOffset.bottomCenter,
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style:
//                       ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   child: Text(
//                     'Inscription',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
