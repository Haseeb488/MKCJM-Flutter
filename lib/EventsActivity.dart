import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mkcjm/PrayerActivity.dart';
import 'HadithActivity.dart';
import 'QuranIntegration/main2.dart';
import 'WebActivity.dart';

class EventsActivity extends StatefulWidget {
  const EventsActivity({Key? key}) : super(key: key);

  @override
  State<EventsActivity> createState() => _EventsActivityState();
}

class _EventsActivityState extends State<EventsActivity> {
  int _currentIndex = 3;

  List<String> event =[];
  List<String> eventDescription = [];
  List<String> eventDate = [];
  List<String> eventTime = [];

  bool eventAvailability = false;

  void getRequest() async {
    //replace your restFull API here.
    String url = "https://onpointglobal.co.uk/mkcjm/events.php";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    if (response.body.length < 5) {
      setState(() {
        eventAvailability = true;
      });
    }

    //Creating a list to store input data;
 //   List<User> users = [];
    for (var singleUser in responseData) {
      String eventName = singleUser["eventName"];
      String description = singleUser["description"];
      String date = singleUser["eventDate"];
      String time = singleUser["eventTime"];

      setState(() {
        event.add(eventName);
        eventDescription.add(description);
        eventDate.add(date);
        if(time == "")
          {
            time = "not required";
          }
        eventTime.add(time);
        return;
      });

    }

  }


  @override
  void initState() {
    // TODO: implement initState
    getRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("MKCJM Mosque Events",
        style: TextStyle(
          color: Colors.white,
        ),),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff00101F),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            child: ListView.builder(
              itemCount: event.length,

              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,

                      colors: [
                        Color(0xff00365c),
                        Color(0xff00101F),
                      ]
                    ),

                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),


                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(event[index],
                              style:TextStyle(
                                color: Color(0xff1DFDEF),
                                fontSize: 20,
                                  fontFamily: 'Serif',
                                  fontWeight: FontWeight.bold
                              ),
                            ),

                            SizedBox(height: 12,),

                            Text(eventDescription[index],
                              style: TextStyle(
                                color: Color(0xffADD8E6),
                                fontSize: 18,
                                fontFamily: 'Serif',
                              ),
                            ),

                            SizedBox(height: 15,),

                            Text("Date: "+eventDate[index] +"             "+"Time: "+eventTime[index],
                              style: TextStyle(
                                color: Color(0xffADD8E6),
                                fontSize: 16,
                                fontFamily: 'Serif',
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Center(
            child: Visibility(
              visible: eventAvailability,
              child: Container(
                child: Text ("No Event Available",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),),
              ),
            ),
          )
        ],
      ),


      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Color(0xff00101F),
        selectedItemColor: Color(0xff1DFDEF),
        unselectedItemColor: Color(0xff83d2f7),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.my_library_books_outlined),
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
