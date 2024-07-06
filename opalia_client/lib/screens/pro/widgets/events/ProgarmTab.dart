import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Row(
                                      children: [Text(prog.speaker.toString())],
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
