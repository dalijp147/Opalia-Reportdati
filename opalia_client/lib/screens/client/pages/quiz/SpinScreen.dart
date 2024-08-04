import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../bloc/score/score_bloc.dart';
import '../../../../services/local/sharedprefutils.dart';
import 'ScoreScreen.dart';

class SpinWheel extends StatefulWidget {
  final int score;
  const SpinWheel({
    super.key,
    required this.score,
  });

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  StreamController<int> controller = StreamController<int>();
  List<String> items = [
    'Won',
    'Lost',
    'Won',
  ];

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  final ScoreBloc scoreBloc = ScoreBloc();

  void spinWheel() {
    final random = Random();
    final selected = random.nextInt(items.length);
    controller.add(selected);

    Future.delayed(Duration(seconds: 4), () {
      String selectedItem = items[selected];
      if (selectedItem == 'Won') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Félicitaion!'),
              content: Text('Tu as gagné un produit de la gamme Hosper'),
              actions: <Widget>[
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      scoreBloc.add(
                        ScoreAddEvent(
                          PreferenceUtils.getuserid(),
                          '1',
                          widget.score.toString(),
                          true,
                          selectedItem,
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            score: widget.score,
                          ),
                        ),
                      );
                    }),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Try Again!'),
              content: Text('You did not win this time.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    scoreBloc.add(
                      ScoreAddEvent(PreferenceUtils.getuserid(), '1',
                          widget.score.toString(), false, 'pas de cadeau'),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(
                          score: widget.score,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  final selected = BehaviorSubject<int>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourné pour gagner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FortuneWheel(
              animateFirst: false,
              selected: controller.stream,
              items: [
                for (var item in items) FortuneItem(child: Text(item)),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 250,
            child: ElevatedButton(
              onPressed: spinWheel,
              child: Text(
                'Spin the Wheel!',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
