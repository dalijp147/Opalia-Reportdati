import 'package:opalia_client/models/events.dart';
import 'package:opalia_client/models/medecin.dart';

List<Programme> programmeFromJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => Programme.fromMap(json as Map<String, dynamic>))
      .toList();
}

class Programme {
  late String? programmeID;

  late String? event;
  late List<Prog>? prog;

  Programme({
    this.programmeID,
    this.event,
    this.prog,
  });
  factory Programme.fromMap(Map<String, dynamic> json) {
    var progList = json['prog'] as List;
    List<Prog> progItems = progList.map((i) => Prog.fromJson(i)).toList();

    return Programme(
      programmeID: json['_id'],
      prog: progItems,
      event: json['event'],
      //  json['event'] != null
      //     ? Events.fromMap(json['event'] as Map<String, dynamic>)
      //     : null,
    );
  }
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> progItems =
        prog!.map((i) => i.toJson()).toList();
    return {
      '_id': programmeID,
      'event': event,
      'prog': progItems,
    };
  }
}

class Prog {
  final DateTime time;
  final String title;
  final List<String> speaker;

  Prog({
    required this.time,
    required this.title,
    required this.speaker,
  });

  factory Prog.fromJson(Map<String, dynamic> json) {
    var speakerList = json['speaker'] as List;
    List<String> speakerItems = List<String>.from(speakerList);

    return Prog(
      time: DateTime.parse(json['time']),
      title: json['title'],
      speaker: speakerItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'title': title,
      'speaker': speaker,
    };
  }
}
