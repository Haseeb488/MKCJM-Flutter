import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkcjm/EventsActivity.dart';
import 'package:mkcjm/push_notification.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Notifiers.dart';
import 'PrayerActivity.dart';
import 'package:mkcjm/HadithActivity.dart';
import 'QuranIntegration/main2.dart';
import 'data.dart';
import 'notification_badge.dart';
import 'package:real_volume/real_volume.dart';
import 'package:http/http.dart' as http;

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print("Handling a background message: ${message.messageId}");
}


class WebActivity extends StatefulWidget {
  const WebActivity({super.key});

  @override
  _WebActivityState createState() => _WebActivityState();
}

class _WebActivityState extends State<WebActivity> {


  final style = const TextStyle(fontSize: 24, color: Colors.white54);
  int _currentIndex = 1;
  bool unMuteButtonVisible = false;
  bool muteButtonVisible = true;
  bool muteIconVisible = false;

  bool badgeVisibility = false;

  int totalNotifications = 0;

  bool onlineStatus = false;
  bool offlineStatus = false;

  String soundStatus = "No Broadcast";
  double currentVolume = 0;
  int number = 0;

  String? selectedMode = "Application";
  late SharedPreferences preferences;

  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  Timer? timer;

  String broadcastingStatus = "";

  late http.Response soundStatusResponse;

  void requestAndRegisterNotification() async {
    // 1. Initialize the Firebase app
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //print('User granted permission');
      String? token = await _messaging.getToken();
      print("The token is ${token!}");
      // For handling the received notifications

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: const Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    // Delay the invocation of showProgressDialog by 100 milliseconds
    Future.delayed(const Duration(milliseconds: 100), () {
      showProgressDialog();
    });

    startTimer();

    requestAndRegisterNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });

    RealVolume.onVolumeChanged.listen((event) {
      double cVolume = event.volumeLevel * 10;
     // Fluttertoast.showToast(msg: "current volume " + cVolume.toString());

      setState(() {
        String s = cVolume.toStringAsFixed(2);
        currentVolume = double.parse(s);
      });
    });

    super.initState();
    init();
  }

  Future init() async
  {
    preferences = await SharedPreferences.getInstance();
    selectedMode = preferences.getString('selectedMode');

    if (selectedMode == null) {
      selectedMode = "Application";
      print("selected mode is null");
      FirebaseMessaging.instance.subscribeToTopic("Application");
      return;
    }

    else {
      print("selected mode is ${selectedMode!}");

      if (selectedMode == "No Alert Mode") {
        FirebaseMessaging.instance.unsubscribeFromTopic("Application");
        print("Successfully unsubscribed from topic Application");
      }
      setState(() => selectedMode = selectedMode);
    }
  }

  @override
  Widget build(BuildContext context) {

    Color getColor() {
      if (number == 0) {
        return const Color(0xffADD8E6);
      }
      else if (number == 1) {
        return Colors.red;
      }
      return Colors.yellowAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Streaming Player",
        style: TextStyle(
          color: Colors.white
        ),),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff00101F),
        actions: [
          PopupMenuButton<String>(onSelected: (value) {
            if (value == "Preferences") {
              showSingleChoiceDialog(context);

              Fluttertoast.showToast(
                  msg: "you have selected preferences",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }

            if (value == "Contact Us") {
              Fluttertoast.showToast(
                  msg: "you have selected Contact Us",
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }, itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                value: "Preferences",
                child: Text("Preferences"),
              ),
              const PopupMenuItem(
                value: "Contact Us",
                child: Text("Contact Us"),
              ),
            ];
          }),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
            ),
          ),
          SizedBox(
            height: 0,
            width: 0,
            child: WebView(
              //    key: UniqueKey(),
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: "https://mkcjm-org-uk.host3.dynamicblend.co.uk:65533/mkcjm",

              onWebViewCreated: (WebViewController webViewController) {},
            ),
          ),
          Visibility(
            visible: offlineStatus,
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 300),
              child: const Text(
                "Mosque is Not Broadcasting",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Serif",
                ),
              ),
            ),
          ),

          Visibility(
            visible: onlineStatus,
            child: Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 300),
              child: const Text(
                "Mosque is Live Now",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: "Serif",
                ),
              ),
            ),
          ),


          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 90, right: 120),
            child: const Text(
              "Current Mode",
              style: TextStyle(
                color: Color(0xffADD8E6),
                fontSize: 18,
                fontFamily: "Serif",
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 90, left: 170),

            child: Text(
              "$selectedMode",
              style: const TextStyle(
                color: Color(0xffADD8E6),
                fontSize: 18,
                fontFamily: "Serif",
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 170, right: 120),
            child: const Text(
              "Sound Volume",
              style: TextStyle(
                color: Color(0xffADD8E6),
                fontSize: 18,
                fontFamily: "Serif",
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 170, left: 180),
            child: Text(
              currentVolume.toString(),
              style: TextStyle(
                color: getColor(),
                fontSize: 18,
                fontFamily: "Serif",
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: muteButtonVisible,
              child: Container(
                height: 65,
                width: 240,
                margin: const EdgeInsets.only(left: 30, top: 320),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white54,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff00101F),
                      Color(0xff00365c),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (muteButtonVisible == true) {
                        muteButtonVisible = false;
                        unMuteButtonVisible = true;
                        muteIconVisible = true;


                        setState(() {

                          muteVolume();
                          soundStatus = "Muted";
                          number = 1;
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        'Mute',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Serif",
                          fontSize: 27.0,
                          color: Colors.white54,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.volume_mute,
                          color: Colors.white54,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: unMuteButtonVisible,
              child: Container(
                height: 65,
                width: 240,
                margin: const EdgeInsets.only(left: 30, top: 320),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white54,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xff00101F),
                      Color(0xff00365c),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (unMuteButtonVisible == true) {
                        unMuteButtonVisible = false;
                        muteButtonVisible = true;
                        muteIconVisible = false;

                        setState(() {
                         RealVolume.setVolume(0.6, showUI: true, streamType: StreamType.MUSIC);
                          number = 0;
                        });
                      }
                    });
                    //write your onPressed function here
                    print('Pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: const Text(
                          'UnMute',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Serif",
                            fontSize: 27.0,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white54,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 65,
              width: 240,
              margin: const EdgeInsets.only(left: 30, top: 480),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white54,
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff00101F),
                    Color(0xff00365c),
                  ],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                showAlertDialog();
                },
                style: ElevatedButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 30),
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Serif",
                          fontSize: 27.0,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.exit_to_app,
                        color: Colors.white54,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: muteIconVisible,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(
                "assets/mute.png",
                color: Colors.red,
                height: 40,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        //  backgroundColor: const Color(0xff00101F),
        selectedItemColor: const Color(0xff1DFDEF),
        unselectedItemColor: const Color(0xff83d2f7),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [

          const BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: ("Daily Hadith"),
            backgroundColor: Color(0xff00101F),
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/livestreamicon.png")),
            label: ("LiveStreaming"),
            backgroundColor: Color(0xff00101F),
          ),
          const BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/clockicon.png")),
            label: ("Prayer Timing"),
            backgroundColor: Color(0xff00101F),
          ),
          BottomNavigationBarItem(
            icon: buildCustomBadge(
                counter: 1,
                child: const Icon(Icons.event_note_outlined)),
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

            if (index == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => const HadithActivity(),
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
                  transitionDuration: const Duration(milliseconds: 0),
                ),
              );
            }


            if (index == 3) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => const EventsActivity(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 0),
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

  void muteVolume() async
  {
    RealVolume.setVolume(0.0, showUI: true, streamType: StreamType.MUSIC);
  }

  void showAlertDialog() {
    Widget onPositiveButton = TextButton(
        onPressed: () {
          exit(0);
        },
        child: const Text("Yes"));

    Widget onNegativeButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text("No"));

    AlertDialog dialog = AlertDialog(
      actions: [onNegativeButton, onPositiveButton],
      title: const Text("Exit"),
      content: const Text("Are you sure to Exit from the App?"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  showSingleChoiceDialog(BuildContext context) =>
      showDialog(
          context: context,
          builder: (context) {
            final _singleNotifier = Provider.of<SingleNotifier>(context);
            return AlertDialog(
              title: const Text('Select Preference Mode'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: Modes
                        .map((f) =>
                        RadioListTile(
                          title: Text(f),
                          value: f,
                          groupValue: _singleNotifier.currentMode,
                          selected: _singleNotifier.currentMode == f,
                          onChanged: (value) {
                            _singleNotifier.updateMode(value.toString());

                            setState(() {
                              selectedMode =
                                  _singleNotifier.currentMode.toString();
                            });

                            Fluttertoast.showToast(
                                msg: "Preference set to ${_singleNotifier.currentMode}"
                            );
                            preferences.setString(
                                "selectedMode", selectedMode!);
                            setState(() =>
                            selectedMode =
                            preferences.getString("selectedMode")!);

                            Navigator.of(context).pop();
                          },
                        ))
                        .toList(),
                  ),
                ),
              ),
            );
          });

  void choiceAction(String choice) {
    print("Working");
  }

  void showProgressDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Make the background transparent
          content: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color:  const Color(0xff00365c), // Set the desired background color
              borderRadius: BorderRadius.circular(8.0), // Optionally, set border radius
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ), // Circular loading indicator
                SizedBox(height: 16.0), // SizedBox for spacing
                Text("Checking for Broadcasting..",
                style: TextStyle(
                  color: Colors.white,
                ),), // Message
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> startTimer() async {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      //place you code for calling after,every 60 seconds.
      getSoundStatus();
    });
  }

/*
  void getBroadcastingStatus() async {
    getSoundStatus();

    String url = "https://onpointglobal.co.uk/mkcjm/jsonStatus.php";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);

    for (var singleUser in responseData) {
      broadcastingStatus = singleUser["StreamingURL"];
      print("status is " + broadcastingStatus);
    }
  }
*/

  bool popExecuted = false;
  void getSoundStatus() async {
    String url = "https://mkcjm-org-uk.host3.dynamicblend.co.uk:65533/mkcjm";
    soundStatusResponse = await http.get(Uri.parse(url));
    print("response data ${soundStatusResponse.statusCode}");

    if (soundStatusResponse.statusCode == 404 && !popExecuted) {
      // Fluttertoast.showToast(msg: "Response code ${soundStatusResponse.statusCode}");
      setState(() {
        offlineStatus = true;
        timer?.cancel();
      });
      Navigator.pop(context);
      popExecuted = true; // Set the flag to true after popping the context
      return;
    } else {

      if(popExecuted == false) {
        // Fluttertoast.showToast(msg: "pop status " + popExecuted.toString());
        Navigator.pop(context);
      }
    // Fluttertoast.showToast(msg: "Response code ${soundStatusResponse.statusCode}");
      setState(() {
        popExecuted = true;
        offlineStatus = false;
        onlineStatus = true;
      });
      return;
    }
  }


  buildCustomBadge({
    required int counter,
    required Icon child
  }) {

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,

        Positioned(
          top: -6,
          right: -20,
          child: Visibility(
            visible: badgeVisibility,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10,

              child: Text(
                totalNotifications.toString(),

                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],

    );
  }

  void getRequest() async {
    //replace your restFull API here.
    String url = "https://onpointglobal.co.uk/mkcjm/events.php";
    final response = await http.get(Uri.parse(url));
    var responseData = json.decode(response.body);
    for (var singleUser in responseData) {
      String eventName = singleUser["eventName"];
      totalNotifications = totalNotifications+1;
    }
    if(totalNotifications > 0)
      {
        setState(() {
          badgeVisibility = true;
        });
      }

  }
}
