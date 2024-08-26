import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/events.dart';
import '../../../../models/particpant.dart';
import '../../../../services/remote/apiServicePro.dart';
import '../../pages/Events/Participant/DetailParticipant.dart';

class ParticipantTab extends StatefulWidget {
  final Events event;
  const ParticipantTab({super.key, required this.event});

  @override
  State<ParticipantTab> createState() => _ParticipantTabState();
}

class _ParticipantTabState extends State<ParticipantTab> {
  List<Particpant>? allParticpant;
  bool isLoading = true;

  Future<void> _fetchParticipantbyevent() async {
    try {
      final participant =
          await ApiServicePro.fetchspeakerbyevent(true, widget.event.EventId!);
      setState(
        () {
          allParticpant = participant;
          isLoading = false;
        },
      );
    } catch (e) {
      print('Failed to fetch participant: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchParticipantbyevent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Liste des orateurs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : allParticpant == null || allParticpant!.isEmpty
                ? Center(child: Text('pas de speaker '))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: allParticpant!.length, // total number of items
                    itemBuilder: (context, index) {
                      final parti = allParticpant![index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(DetailParticipant(
                            specialite: parti.doctorId!.specialite!,
                            description: parti.description!,
                            image: parti.doctorId!.image!,
                            nom: parti.doctorId!.name!,
                            prenom: parti.doctorId!.familyname!,
                            event: parti.eventId!,
                            DocId: parti.doctorId!,
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 170,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 100,
                                      width: 150,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  (parti.doctorId!.image == null ||
                                          parti.doctorId!.image == "")
                                      ? "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"
                                      : parti.doctorId!.image!,
                                  height: double.infinity,
                                  width: 100,
                                  fit: BoxFit.fitHeight,
                                  errorBuilder: (BuildContext context,
                                      Object error, StackTrace? stackTrace) {
                                    // You can add logging here to see what the error is
                                    print('Error loading image: $error');
                                    return Image.network(
                                      height: 100,
                                      width: 100,
                                      "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg",
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 45,
                                    left: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text(
                                          'DR ' +
                                              parti.doctorId!.name! +
                                              ' ' +
                                              parti.doctorId!.familyname!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      parti.doctorId!.specialite != null
                                          ? Text('Specialité : ' +
                                              parti.doctorId!.specialite!)
                                          : Text('Data introuvable  ')
                                    ],
                                  ),
                                ),
                                //),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
