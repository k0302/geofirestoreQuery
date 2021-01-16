import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final DocumentSnapshot to;

  NotificationPage({
    @required this.to,
  });

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController _messageController = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;

  @override
  void initState() {
    fetchUser();
    super.initState();
  }

  fetchUser() async {
    User u = await auth.currentUser;
    setState(() {
      user = u;
    });
  }

  handleInput(String input) {
    db.collection("users").doc(widget.to.id).collection("notifications").add({
      "message": input,
      "sentBy": user.email,
      "date": FieldValue.serverTimestamp()
    }).then((doc) {
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.to.data()["email"]),
      ),
      body: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Write message here",
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  handleInput(_messageController.text);
                },
                child: Icon(Icons.send),
              )
            ],
          ),
        ),
      ),
    );
  }
}
