import 'dart:convert';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:mkcjm/EventsActivity.dart';
import 'package:mkcjm/HadithActivity.dart';
import 'package:mkcjm/WebActivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'QuranIntegration/main2.dart';

class PrayerActivity extends StatefulWidget {
  @override
  _PrayerActivityState createState() => _PrayerActivityState();
  late FirebaseMessaging firebaseMessaging;
}

class _PrayerActivityState extends State<PrayerActivity> {
  String myText = "بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيمِ";

  int _currentIndex = 2;

  String Fazan = "00:00";
  String Sunrise = "00:00";
  String Zazan = "00:00";
  String Aazan = "00:00";
  String Mazan = "00:00";
  String Eazan = "00:00";

  String Fjamah = "00:00";
  String Zjamah = "00:00";
  String Ajamah = "00:00";
  String Mjamah = "00:00";
  String Ejamah = "00:00";

  bool visible = true;

  Future getRequest() async {
    //replace your restFull API here.

    String url = "https://onpointglobal.co.uk/mkcjm/praytime.php";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    //Creating a list to store input data;

    for (var singleUser in responseData) {
      String fajrA = singleUser["fajr"];
      String sunrise = singleUser["sunrise"];
      String zuhrA = singleUser["zuhr"];
      String asrA = singleUser["asr"];
      String maghribA = singleUser["maghrib"];
      String eshaA = singleUser["isha"];
      String fajrJ = singleUser["fajr_jamah"];
      String zuhrJ = singleUser["zuhr_jamah"];
      String asrJ = singleUser["asr_jamah"];
      String maghribJ = singleUser["maghrib_jamah"];
      String eshaJ = singleUser["isha_jamah"];

      setState(() {
        visible = false;
        Fazan = fajrA;
        Sunrise = sunrise;
        Zazan = zuhrA;
        Aazan = asrA;
        Mazan = maghribA;
        Eazan = eshaA;
        Fjamah = fajrJ;
        Zjamah = zuhrJ;
        Ajamah = asrJ;
        Mjamah = maghribJ;
        Ejamah = eshaJ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today Prayer Timings",
        style:  TextStyle(
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff00101F),
      ),
      body: Stack(children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/praybackground.png"),
              fit: BoxFit.fill,
            ),
          ),
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              builder:
              if (visible == true) {
                return Container(
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),


        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.65 ,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.19,
            ),
            alignment: Alignment.topCenter,
            child: FittedBox(
              child: AutoSizeText(
                "بِسْمِ اللَّـهِ الرَّحْمَـٰنِ الرَّحِيم",
                style: TextStyle(
                    color: Color(0xffADD8E6),
                    fontSize: 50.0,
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.bold),
                    maxLines: 1,
              ),
            ),
          ),
        ),

        //    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              height: 40,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.6,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: FittedBox(
                child: AutoSizeText(
                  "Azan",
                  style:
                  TextStyle(
                      color: Color(0xff1DFDEF),
                      fontSize: 35.0,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
              ),
            ),

            Container(
              height: 40,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.6,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),

              child: FittedBox(
                child: const Text(
                  "Jam'ah",
                  style: TextStyle(
                      color: Color(0xff38B8F7),
                      fontSize: 27.0,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
            ),
            ),
          ],

        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              margin:EdgeInsets.only(
                top:  MediaQuery.of(context).size.height * 0.35),

              child: FittedBox(
                child: AutoSizeText(
                  "Fajar",
                  style: TextStyle(
                      color: Color(0xffADD8E6),
                      fontSize: 18.0,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold),

                  maxLines: 1,
                ),

              ),
            ),
          ],
        ),

        Container(
          height: 35,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.04),
          child: FittedBox(
            child: AutoSizeText(
              "$Fazan".substring(0,5),
              style: const TextStyle(
                color: Color(0xff1DFDEF),
                fontSize: 27.0,
                fontFamily: 'Serif',
              ),
            ),
          ),
        ),

        Container(
            height: MediaQuery.of(context).size.height * 0.031,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.41
            ),
            alignment: Alignment.center,
            child: FittedBox(
              child: AutoSizeText(
                "Sunrise: $Sunrise".substring(0, 14),
                style: const TextStyle(
                  color: Color(0xfff7db00),
                  fontSize: 27.0,
                  fontFamily: 'Serif',
                ),
                maxLines: 1,
              ),
        ),
        ),

        /*
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.4,
            //   left: MediaQuery.of(context).size.width*0.55
          ),
          child: FittedBox(
            child: AutoSizeText(
              "Sunrise: $Sunrise".substring(0, 14),
              style: const TextStyle(
                color: Color(0xfff7db00),
                fontSize: 23.0,
                fontFamily: 'Serif',
              ),
            maxLines: 1,
            ),
          ),
        ),
*/
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.46),
          child: FittedBox(
            child: AutoSizeText(
              "Zuhr",
              style: TextStyle(
                  color: Color(0xffADD8E6),
                  fontSize: 40.0,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold),
            maxLines: 1,
            ),
          ),
        ),

        Container(

          height: 35,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.49,
              left: MediaQuery.of(context).size.width * 0.04),
          child: AutoSizeText(
            "$Zazan".substring(0,5),
            style: const TextStyle(
              color: Color(0xff1DFDEF),
              fontSize: 50.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),



        Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.54),
          child: FittedBox(
            child: AutoSizeText(
              "Asr",
              style: TextStyle(
                  color: Color(0xffADD8E6),
                  fontSize: 40.0,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ),


        Container(
          height: 35,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.58,
              left: MediaQuery.of(context).size.width * 0.04),
          child: AutoSizeText(
            "$Aazan".substring(0,5),
            style: const TextStyle(
              color: Color(0xff1DFDEF),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.63),
          child: FittedBox(
            child: AutoSizeText(
              "Maghrib",
              style: TextStyle(
                  color: Color(0xffADD8E6),
                  fontSize: 40.0,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ),


        Container(
          height: 35,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.67,
              left: MediaQuery.of(context).size.width * 0.04),
          child: AutoSizeText(
            "$Mazan".substring(0,5),
            style: const TextStyle(
              color: Color(0xff1DFDEF),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        Container(
          height: 40,
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.72),
          child: FittedBox(
            child: AutoSizeText(
              "Esha",
              style: TextStyle(
                  color: Color(0xffADD8E6),
                  fontSize: 40.0,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          ),
        ),

        Container(
          height: 35,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.76,
              left: MediaQuery.of(context).size.width * 0.04),
          child: AutoSizeText(
            "$Eazan".substring(0,5),
            style: const TextStyle(
              color: Color(0xff1DFDEF),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        //Jamah starts from here
/*
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.6,
              left: MediaQuery.of(context).size.width * 0.7),
          child: FittedBox(
            child: const Text(
              "Jam'ah",
              style: TextStyle(
                  color: Color(0xff38B8F7),
                  fontSize: 27.0,
                  fontFamily: 'Serif',
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
*/

        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
              right: MediaQuery.of(context).size.width * 0.08
            ),
          height: 35,
          child: FittedBox(
            child: AutoSizeText(
              "$Fjamah".substring(0,5),
              style: const TextStyle(
                color: Color(0xff38B8F7),
                fontSize: 40.0,
                fontFamily: 'Serif',
              ),
              maxLines: 1,
            ),
          ),
        ),


        Container(

          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.49,
              right: MediaQuery.of(context).size.width * 0.08),
          height: 35,
          child: FittedBox(
            child: AutoSizeText (
              "$Zjamah".substring(0,5),
              style: const TextStyle(
                color: Color(0xff38B8F7),
                fontSize: 40.0,
                fontFamily: 'Serif',
              ),
            ),
          ),
        ),


        Container(

          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.580,
              right: MediaQuery.of(context).size.width * 0.08),
          height: 35,
          child: AutoSizeText(
            "$Ajamah".substring(0,5),
            style: const TextStyle(
              color: Color(0xff38B8F7),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.670,
              right: MediaQuery.of(context).size.width * 0.08),
          height: 35,
          child: AutoSizeText(
            "$Mjamah".substring(0,5),
            style: const TextStyle(
              color: Color(0xff38B8F7),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.76,
              right: MediaQuery.of(context).size.width * 0.08),
           height: 35,
          child: AutoSizeText(
            "$Ejamah".substring(0,5),
            style: const TextStyle(
              color: Color(0xff38B8F7),
              fontSize: 40.0,
              fontFamily: 'Serif',
            ),
            maxLines: 1,
          ),
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 2,
              color: const Color(0xff00101F),
            ),
          ],
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color(0xff00101F),
        selectedItemColor: Color(0xff1DFDEF),
        unselectedItemColor: Color(0xff83d2f7),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books_outlined),
            label: ("Daily Hadith"),
            backgroundColor: Color(0xff00101F),
          ),
          BottomNavigationBarItem(
            icon: new ImageIcon(AssetImage("assets/livestreamicon.png")),
            label: ("LiveStreaming"),
            backgroundColor: Color(0xff00101F),
          ),
          BottomNavigationBarItem(
            icon: new ImageIcon(AssetImage("assets/clockicon.png")),
            label: ("Prayer Timings"),
            backgroundColor: Color(0xff00101F),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: ("Events"),
            backgroundColor: const Color(0xff00101F),
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: ("Quran"),
            backgroundColor: Color(0xff00101F),
          ),

        ],

        onTap: (index) {
          setState(() {
            _currentIndex = index;

            if (index == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => const HadithActivity(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 0),
                ),
              );
            }

            if (index == 1) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => WebActivity(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 0),
                ),
              );
            }

            if (index == 3) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => EventsActivity(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 0),
                ),
              );
            }
            if (index == 4) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => const QuranFirstScreen(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 0),
                ),
              );
            }

          });
        },
      ),
    );
  }
}
