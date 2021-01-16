//====================== notification with old plugin ===================
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:phoneauth/notification/LoginScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(App());
// }

// class App extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }

//========================= chatting ============================
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:phoneauth/chatting/login.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       home: Login(),
//     );
//   }
// }
//========================== chatapp ==============================

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:phoneauth/chatapp/helper/authenticate.dart';
// import 'package:phoneauth/chatapp/helper/sharedpref.dart';
// import 'package:phoneauth/chatapp/views/chatroom.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool userIsLoggedIn;

//   @override
//   void initState() {
//     getLoggedInState();
//     super.initState();
//   }

//   getLoggedInState() async {
//     await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
//       setState(() {
//         userIsLoggedIn = value;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'FlutterChat',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xff145C9E),
//         scaffoldBackgroundColor: Color(0xff1F1F1F),
//         accentColor: Color(0xff007EF4),
//         fontFamily: "OverpassRegular",
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: userIsLoggedIn != null
//           ? userIsLoggedIn
//               ? ChatRoom()
//               : Authenticate()
//           : Container(
//               child: Center(
//                 child: Authenticate(),
//               ),
//             ),
//     );
//   }
// }

//================= cloud functions ==============================
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(CloudFunction());
// }

// class CloudFunction extends StatefulWidget {
//   CloudFunction() : super();
//   final String title = 'Cloud Function Notif';

//   @override
//   _CloudFunctionState createState() => _CloudFunctionState();
// }

// class _CloudFunctionState extends State<CloudFunction> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   List<Message> _messages;

//   _getToken() {
//     _firebaseMessaging.getToken().then((deviceToken) {
//       print('Device Token: $deviceToken');
//     });
//   }

//   _configureFirebaseListeners() {
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//       _setMessage(message);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//       _setMessage(message);
//     }, onResume: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//       _setMessage(message);
//     });
//   }

//   _setMessage(Map<String, dynamic> message) {
//     final notification = message['notification'];
//     final data = message['data'];
//     final String title = notification['title'];
//     final String body = notification['body'];
//     final String mMessage = data['message'];
//     setState(() {
//       Message m = Message(title, body, mMessage);
//       _messages.add(m);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _messages = List<Message>();
//     _getToken();
//     _configureFirebaseListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: ListView.builder(
//             itemCount: null == _messages ? 0 : _messages.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 child: Padding(
//                   padding: EdgeInsets.all(15),
//                   child: Text(
//                     _messages[index].message,
//                     style: TextStyle(fontSize: 16, color: Colors.black),
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }

// class Message {
//   String title, body, message;
//   Message(title, body, message) {
//     this.title = title;
//     this.body = body;
//     this.message = message;
//   }
// }

//=================== geofirestore =========================
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:phoneauth/detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showMessage("Notification", "$message");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPage()));
      },
      onLaunch: (Map<String, dynamic> message) async {
        showMessage("Notification", "$message");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPage()));
      },
      onResume: (Map<String, dynamic> message) async {
        showMessage("Notification", "$message");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPage()));
      },
    );

    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false),
      );
    }

    super.initState();
  }

  showMessage(title, description) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Dismiss"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home')),
    );
  }
}

//================= geoflutterfire ===========================
