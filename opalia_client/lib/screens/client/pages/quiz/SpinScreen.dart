import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

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
  List<String> items = ['', '', 'Hosper', '', 'invitation évenement'];
  @override
  void initState() {
    // showDialog(
    //   context: context,
    //   builder: _buildPopupDialog(context),
    // );

    super.initState();
  }

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  final selected = BehaviorSubject<int>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(''),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 500,
            height: 500,
            child: FortuneWheel(
              selected: selected.stream,
              animateFirst: false,
              items: [
                for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                  FortuneItem(
                    child: Text(items[i]),
                  ),
                }
              ],
              onAnimationEnd: () {
                selected.last.then(
                  (selectedIndex) {
                    final selectedItem = items[selectedIndex];
                    if (selectedItem == 'Hosper' ||
                        selectedItem == 'invitation évenement') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Félicitations!'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Vous avez gagné! Félicitations!'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Fermer'),
                              onPressed: () {
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
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('Perdu'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Désole vous avez perdu essayer une prochaine fois'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Fermer'),
                              onPressed: () {
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
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selected.add(
                  Fortune.randomInt(0, items.length),
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  color: Colors.red,
                ),
                color: Colors.redAccent,
              ),
              height: 40,
              width: 120,
              child: Center(
                child: Text(
                  'Tourner',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
