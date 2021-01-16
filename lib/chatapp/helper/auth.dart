import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:phoneauth/chatapp/helper/user.dart';
//import 'package:phoneauth/chatapp/views/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final googleSignIn = GoogleSignIn();

  Uuser _userFromFirebaseUser(User user) {
    return user != null ? Uuser(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      FirebaseMessaging().onTokenRefresh.listen((newToken) {
        FirebaseFirestore.instance
            .collection('uuusers')
            .doc(user.uid)
            .update({"fcmToken": newToken});
      });
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Future<User> signInWithGoogle(BuildContext context) async {
  //   final GoogleSignIn _googleSignIn = new GoogleSignIn();

  //   final GoogleSignInAccount googleSignInAccount =
  //       await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //       idToken: googleSignInAuthentication.idToken,
  //       accessToken: googleSignInAuthentication.accessToken);

  //   UserCredential result = await _auth.signInWithCredential(credential);
  //   //FirebaseUser userDetails = result.user;
  //   if (result == null) {
  //   } else {
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
  //   }
  // }

  handleSignIn() async {
    final res = await googleSignIn.signIn();

    final auth = await res.authentication;

    final credentials = GoogleAuthProvider.credential(
        idToken: auth.idToken, accessToken: auth.accessToken);

    final firebaseUser = (await _auth.signInWithCredential(credentials)).user;

    if (firebaseUser != null) {
      String fcmToken = await firebaseMessaging.getToken();
      final result = (await FirebaseFirestore.instance
              .collection('uuusers')
              .where('id', isEqualTo: firebaseUser.uid)
              .get())
          .docs;

      if (result.length == 0) {
        ///new user
        FirebaseFirestore.instance
            .collection('uuusers')
            .doc(firebaseUser.uid)
            .set({
          "id": firebaseUser.uid,
          "name": firebaseUser.displayName,
          "fcmToken": fcmToken,
          "profile_pic": firebaseUser.photoURL,
          "created_at": FieldValue.serverTimestamp()
        });

        //Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
      } else {
        ///old user
        FirebaseFirestore.instance
            .collection('uusers')
            .doc(firebaseUser.uid)
            .update({"fcmToken": fcmToken});
        // SetOptions(merge: true));
        print(fcmToken);

        //Navigator.push(context, MaterialPageRoute(builder: (context) => Chat()));
      }
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
