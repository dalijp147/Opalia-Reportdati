import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../bloc/score/score_bloc.dart';
import '../../../../services/local/sharedprefutils.dart';
import 'ScoreScreenPro.dart';

class SpinWheelPro extends StatefulWidget {
  final int score;
  const SpinWheelPro({
    super.key,
    required this.score,
  });

  @override
  State<SpinWheelPro> createState() => _SpinWheelProState();
}

class _SpinWheelProState extends State<SpinWheelPro> {
  StreamController<int> controller = StreamController<int>();
  List<String> items = ['perdu', 'Hosper', 'perdu', 'IALUFRESH'];

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
      if (selectedItem == 'Hosper' || selectedItem == 'IALUFRESH') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Félicitation!'),
              content: Text('Tu as gagné un produit de la gamme Hosper'),
              actions: <Widget>[
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      scoreBloc.add(
                        ScoreAddEventPro(
                          PreferenceUtils.getuserid(),
                          '1',
                          widget.score.toString(),
                          true,
                          selectedItem,
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ResultScreenPro(
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
                      ScoreAddEventPro(PreferenceUtils.getuserid(), '1',
                          widget.score.toString(), false, "pas de cadeau"),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ResultScreenPro(
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
        title: Text('Niveau 2'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FortuneWheel(
              animateFirst: false,
              selected: controller.stream,
              items: [
                for (var item in items)
                  FortuneItem(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: FortuneItemStyle(
                      color: const Color.fromARGB(
                          255, 216, 50, 38), // Background color
                      borderColor: Colors.white, // Border color
                      borderWidth: 3.0, // Border width
                    ),
                  ),
              ],
              indicators: <FortuneIndicator>[
                FortuneIndicator(
                  alignment: Alignment
                      .topCenter, // Change alignment to desired position
                  child: TriangleIndicator(
                    color: Colors.white, // Indicator color
                  ),
                ),
              ],
              physics: CircularPanPhysics(
                duration: Duration(seconds: 1),
                curve: Curves.decelerate,
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            child: ElevatedButton(
              onPressed: spinWheel,
              child: Text(
                'Tourner la roue de la chance!',
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
