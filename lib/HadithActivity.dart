import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mkcjm/EventsActivity.dart';

import 'PrayerActivity.dart';
import 'QuranIntegration/main2.dart';
import 'WebActivity.dart';

class User {

  final String title;
  final String body;

  User({
    required this.title,
    required this.body,
  });
}

class HadithActivity extends StatefulWidget {
  const HadithActivity({Key? key}) : super(key: key);

  @override
  State<HadithActivity> createState() => _HadithActivityState();
}

class _HadithActivityState extends State<HadithActivity> {

  String myText = "Hadiths of the Day";
  int _currentIndex = 0;

  Future<List<User>> getRequest() async {
    //replace your restFull API here.
   String url = "https://onpointglobal.co.uk/mkcjm/hadith.php";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    //Creating a list to store input data;
    List<User> users = [];
    for (var singleUser in responseData) {
      String name = singleUser["Hadith"];

      User user = User(
          title: singleUser["Hadith"],
          body: singleUser["Ref"]
      );
      //Adding user to the list.
      users.add(user);
    }
    return users;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text("Daily Hadith",
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff00101F),
          ),
          body:

          Stack(

            children: <Widget>
            [

              Container(
                decoration:const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.fill
                  ),
                ),
                child: FutureBuilder(
                  future: getRequest(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) =>
                            ListTile(
                              title: Text(snapshot.data[index].title,
                                style: const TextStyle(
                                    color: Color(0xff38B8F7),
                                    fontSize: 30.0,
                                    fontFamily: "Serif"
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(snapshot.data[index].body,
                                style: const TextStyle(
                                  color: Color(0xff1DFDEF),
                                  fontSize: 25.0,
                                  fontFamily: "serif",
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              //contentPadding: EdgeInsets.only(top: 350,right: 20,left: 15),
                              contentPadding: EdgeInsets.only(top: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.4),

                            ),

                      );
                    }
                  },
                ),
              ),



              Container(
                margin: EdgeInsets.only(bottom: MediaQuery
                    .of(context)
                    .size
                    .width * 0.4),
                alignment: Alignment.center,

                child: Text("$myText",
                  style: const TextStyle(
                      color: Color(0xffADD8E6),
                      fontSize: 27.0,
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),



            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
         //   backgroundColor: const Color(0xff00101F),
            selectedItemColor: const Color(0xff1DFDEF),
            unselectedItemColor: const Color(0xff83d2f7),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(icon: new Icon(
                  Icons.library_books_outlined),
                 label: ("Daily Hadith"),
                 backgroundColor: const Color(0xff00101F),
              ),

              BottomNavigationBarItem(

                icon: new ImageIcon(
                    AssetImage("assets/livestreamicon.png")),
                label: ("LiveStreaming"),
                backgroundColor: const Color(0xff00101F),

              ),


              BottomNavigationBarItem(
                icon: new ImageIcon(
                    AssetImage("assets/clockicon.png")),
                label: ("Prayer Timings"),
                backgroundColor: const Color(0xff00101F),
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

                Fluttertoast.showToast(msg: "index: "+index.toString());

                if (index == 1) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => WebActivity(),
                      transitionsBuilder: (c, anim, a2, child) =>
                          FadeTransition(opacity: anim, child: child),
                      transitionDuration: const Duration(milliseconds: 0),
                    ),
                  );
                }

                if (index == 2) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (c, a1, a2) => PrayerActivity(),
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

        )
    );
  }
}
