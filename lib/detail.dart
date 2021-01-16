import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Page'),
      ),
      body: Center(child: Text('My Page')),
    );
  }
}

// class Notif {
//   final String uid;
//   final String field;
//   final String address;

//   Notif({
//     this.uid,
//     this.field,
//     this.address,
//   });
// }

// class DatabaseService {
//   final String uid;
//   DatabaseService({this.uid});
//   //brewlist from snapshot for mypage
//   List<Notif> _notifListFromSnapshot(QuerySnapshot snapshot) {
//     return snapshot.docs.map((doc) {
//       return Notif(
//         uid: uid,
//         field: doc.data()['field'] ?? '',
//         address: doc.data()['address'] ?? '',
//       );
//     }).toList();
//   }

// // get brew stream
//   Stream<List<Notif>> get notifs {
//     final CollectionReference notifCollection = FirebaseFirestore.instance
//         .collection('crews')
//         .doc(uid)
//         .collection('pros')
//         .doc()
//         .collection('notifs');
//     return notifCollection.snapshots().map(_notifListFromSnapshot);
//   }
// }

// class MyPage extends StatefulWidget {
//   @override
//   _MyPageState createState() => _MyPageState();
// }

// class _MyPageState extends State<MyPage> {
//   User user;

//   Future<void> getUserData() async {
//     User userData = FirebaseAuth.instance.currentUser;
//     setState(() {
//       user = userData;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final user = Provider.of<User>(context);
//     return Scaffold(
//       body: Container(
//         color: Colors.grey[700],
//         child: StreamProvider.value(
//             value: DatabaseService(uid: user.uid).notifs, child: NotifList()),
//       ),
//     );
//   }
// }

// class NotifList extends StatefulWidget {
//   @override
//   _NotifListState createState() => _NotifListState();
// }

// class _NotifListState extends State<NotifList> {
//   @override
//   Widget build(BuildContext context) {
//     final notifs = Provider.of<List<Notif>>(context) ?? [];
//     return ListView.builder(
//       itemCount: notifs.length,
//       itemBuilder: (context, index) {
//         return NotifTile(notif: notifs[index]);
//       },
//     );
//   }
// }

// class NotifTile extends StatelessWidget {
//   final Notif notif;
//   NotifTile({this.notif});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 7,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
//       child: Container(
//         margin: EdgeInsets.all(1.5),
//         padding: EdgeInsets.all(10),
//         child: Column(
//           children: [
//             SizedBox(height: 10),
//             Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//               Text(
//                 '   🛍',
//                 style: TextStyle(fontSize: 20),
//               ),
//               Text('    ${notif.field} 고객님은', style: TextStyle(fontSize: 26))
//             ]),
//             SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.only(left: 18, bottom: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("  ${notif.address} 분야의\n 프로님을 구하는 중",
//                       //'${brew.field1}  ${brew.field2} 분야의\n프로님을 구하는 중',
//                       style: TextStyle(fontSize: 20)),
//                   FloatingActionButton(
//                     heroTag: null,
//                     mini: true,
//                     backgroundColor: Colors.red[900],
//                     child: Icon(Icons.call_received),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
