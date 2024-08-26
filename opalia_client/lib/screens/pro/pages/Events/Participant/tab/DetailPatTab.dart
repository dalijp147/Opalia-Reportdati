import 'package:flutter/material.dart';

class DetailTabParticipant extends StatelessWidget {
  final String Description;
  const DetailTabParticipant({super.key, required this.Description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(Description),
    );
  }
}
