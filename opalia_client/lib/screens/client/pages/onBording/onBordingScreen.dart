import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:opalia_client/screens/client/pages/auth/signin.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/opalia-preview.png',
                          width: 150,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bienvenue',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Lottie.asset('assets/animation/health.json',
                          height: 250, width: 250),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Découvrez l'application Opalia Recordati",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "votre compagnon de santé personnel. Elle vous accompagne au quotidien dans la gestion de votre bien-être",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/opalia-preview.png',
                        width: 150,
                      ),
                    ),
                    Lottie.asset('assets/animation/h.json',
                        height: 280, width: 280),
                    Text(
                      'Elle vous offre un suivi médical personnalisé grâce à votre dossier de santé',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/images/opalia-preview.png',
                        width: 150,
                      ),
                    ),
                    Lottie.asset('assets/animation/med.json',
                        height: 280, width: 280),
                    Text(
                      'Elle vous offre un suivi médical personnalisé grâce à votre dossier de santé',
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            alignment: Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.jumpToPage(2);
                  },
                  child: Text('Ignorer'),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                ),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Get.to(SigninScreen());
                        },
                        child: Text('fin'),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text('Suivant'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
