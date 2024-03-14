import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../quran/screen/quran_screen.dart';
import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkDatabaseAvailability(context);
  }


  @override
  Widget build(BuildContext context) {

    // return SplashScaffold();
    return QuranScreen();
  }
}
