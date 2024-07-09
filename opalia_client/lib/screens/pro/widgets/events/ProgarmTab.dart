import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opalia_client/models/particpant.dart';
import 'package:opalia_client/screens/pro/pages/Events/Participant/DetailParticipant.dart';
import 'package:opalia_client/services/remote/apiServicePro.dart';

import '../../../../models/events.dart';
import '../../../../models/programme.dart';

class ProgramTab extends StatefulWidget {
  final Events event;
  const ProgramTab({super.key, required this.event});

  @override
  State<ProgramTab> createState() => _ProgramTabState();
}

class _ProgramTabState extends State<ProgramTab> {
  List<Programme>? allProgramme;
  bool isLoading = true;
  List<Programme>? allPartii;
  Future<void> _fetchProgramme() async {
    try {
      final programme =
          await ApiServicePro.getAllProgramme(widget.event.EventId!);
      setState(() {
        allProgramme = programme;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch programme: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchParticipantByid(String speakerId) async {
    try {
      final parti = await ApiServicePro.getAllProgramme(speakerId);
      setState(() {
        allPartii = parti;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch parti: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProgramme();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : allProgramme == null || allProgramme!.isEmpty
              ? Center(child: Text('pas de programmes '))
              : ListView.builder(
                  itemCount: allProgramme!.length,
                  itemBuilder: (context, index) {
                    final programme = allProgramme![index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...programme.prog!.map(
                          (prog) {
                            String formattedTime =
                                DateFormat.Hm().format(prog.time);
                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        prog.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        FutureBuilder<List<Particpant>>(
                                          future: ApiServicePro
                                              .fetchParticipantsByIds(
                                            prog.speaker,
                                          ),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Particpant>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Column(
                                                children: [
                                                  SizedBox(height: 50),
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ],
                                              );
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot.error}'));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Center(
                                                  child: Text(
                                                      'No participants found'));
                                            } else {
                                              return Expanded(
                                                child: Container(
                                                  height: 100,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final participant =
                                                          snapshot.data![index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(DetailParticipant(
                                                              description:
                                                                  participant
                                                                      .description!,
                                                              image: participant
                                                                  .doctorId!
                                                                  .image!,
                                                              nom: participant
                                                                  .doctorId!
                                                                  .name!,
                                                              specialite:
                                                                  participant
                                                                      .doctorId!
                                                                      .specialite!,
                                                              prenom: participant
                                                                  .doctorId!
                                                                  .familyname!));
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 50,
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                          backgroundImage: participant
                                                                          .doctorId!
                                                                          .image !=
                                                                      null &&
                                                                  participant
                                                                      .doctorId!
                                                                      .image!
                                                                      .isNotEmpty
                                                              ? NetworkImage(
                                                                  participant
                                                                      .doctorId!
                                                                      .image!)
                                                              : NetworkImage(
                                                                  "https://static.vecteezy.com/system/resources/previews/005/337/799/non_2x/icon-image-not-found-free-vector.jpg"),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        // Expanded(
                                        //   child:
                                        // Container(
                                        //     height: 100,
                                        //     child: ListView.builder(
                                        //       itemCount: prog.speaker.length,
                                        //       itemBuilder: (context, index) {
                                        //         final programme =
                                        //             allProgramme![index];

                                        //         return Text(
                                        //             prog.speaker.toString());
                                        //       },
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Divider(height: 4),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ],
                    );
                  },
                ),
    );
  }
}
