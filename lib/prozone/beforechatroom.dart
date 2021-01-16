import 'package:flutter/material.dart';
import 'package:phoneauth/prozone/chat.dart';
import 'package:phoneauth/prozone/database.dart';
import 'package:phoneauth/prozone/helper.dart';

class BeforeChatRoom extends StatefulWidget {
  @override
  _BeforeChatRoomState createState() => _BeforeChatRoomState();
}

class _BeforeChatRoomState extends State<BeforeChatRoom> {
  Userbio userbio;
  Brewbio brewbio;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: RaisedButton(onPressed: () => sendMessage(brewbio.name)),
    ));
  }

  sendMessage(String name) {
    List<String> users = [userbio.name, name];

    String chatRoomId = getChatRoomId(userbio.name, name);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
