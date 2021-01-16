import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/notification/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    checkUserAuth();
    super.initState();
  }

  checkUserAuth() async {
    try {
      User user = auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((authResult) async {
        // register fcm token
        String fcmToken = await firebaseMessaging.getToken();

        User user = authResult.user;

        db
            .collection("users")
            .doc(user.uid)
            .set({"email": user.email, "fcmToken": fcmToken});

        // for topic
        firebaseMessaging.subscribeToTopic("promotion");
        firebaseMessaging.subscribeToTopic("news");

        // for unsubscribe
        // firebaseMessaging.unsubscribeFromTopic("news");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }).catchError((error) {
        showMessage("Alert!", "$error");
      });
    } else {
      // show alert
      print("Provide email & pass");
      showMessage("Alert!", "Provide details");
    }
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
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Email",
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Password",
                  labelText: "Password",
                ),
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Sign In"),
              onPressed: () {
                signIn();
              },
            ),
          ],
        ),
      ),
    );
  }
}
