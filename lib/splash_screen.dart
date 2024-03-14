
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'WebActivity.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {

    Timer(const Duration(seconds: 4), () async {

      await Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => WebActivity()));
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    /* FadeAnimatedText(
                      'Camp With Champs',
                      duration: const Duration(seconds:4),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(fontSize: 30.0,color: Colors.white, fontWeight: FontWeight.bold),
                    ),*/
                    ScaleAnimatedText(
                      'Central Jamia Mosque'+"\n"+"Wolverton",
                      duration: const Duration(seconds: 8),
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(fontSize: 55.0,color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
