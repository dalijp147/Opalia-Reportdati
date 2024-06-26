import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opalia_client/screens/pro/widgets/events/DetailTab.dart';
import 'package:opalia_client/screens/pro/widgets/events/ParticipantTab.dart';

import '../../../../models/events.dart';
import '../../widgets/events/DiscussionTab.dart';
import '../../widgets/events/ProgarmTab.dart';

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
      length: 4,
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
                  text: "Détaille",
                ),
                Tab(
                  text: "Programme",
                ),
                Tab(
                  text: "Discussion",
                ),
                Tab(
                  text: "Participant",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                DetailTab(event: widget.event),
                ProgramTab(event: widget.event),
                DiscussionTab(event: widget.event),
                ParticipantTab(event: widget.event),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
