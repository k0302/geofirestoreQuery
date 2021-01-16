//============= device to device notification functions ========================
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();
// exports.sendNotification = functions.firestore
// .document("users/{user}/notifications/{notification}")
// .onCreate(async (snapshot, context)=> {
//     try {
//          const notificationDocument = snapshot.data()
//         const uid = context.params.user;

//         const notificationMessage = notificationDocument.message;
//         const notificationTitle = notificationDocument.sentBy;

//         const userDoc = await admin.firestore().collection("users").doc(uid).get();

//         const fcmToken = userDoc.data().fcmToken

//         const message = {
//             "notification": {
//                 title: notificationTitle,
//                 body: notificationMessage
//             },
//             token: fcmToken
//         }
//         return admin.messaging().send(message)
//     } catch (error) {
//         console.log(error)
//     }
// })

//=================== chatting functions ===========================================================
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();

//  exports.sendNotification = functions.firestore
// .document("messages/{groupChatId}/chats/{chat}")
// .onCreate( async snapshot => {
//   try {
//     const notificationMessage = snapshot.data().content;
//     const notificationSenderId = snapshot.data().senderId;
//     //const uid = snapshot.data().recipientId;

//     await admin.firestore().collection('uusers').where('id', '==', snapshot.data().recipientId).get()
//           .then(querySnapshot => {
//           const token =  querySnapshot.docs[0].data().fcmToken;
              
//           const message = {
//           "notification": {
//           title: notificationSenderId,
//           body: notificationMessage
//            }, 
//           token: token}
//           return admin.messaging().send(message);
//     });
//   } catch (error) {
//     return console.log(error)
// }
// })

//======================= chatapp ===================================================
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// admin.initializeApp();
// exports.sendNotification = functions.firestore.document("chatRoom/{chatRoomId}/chats/{chat}").onCreate(async snapshot => {
//   try {
    
//     const notificationMessage =  snapshot.data().message;
//     const notificationSenderId =  snapshot.data().sendBy;

//     await admin.firestore().collection('uuusers').where('name', '==', snapshot.data().recipient).get()
//       .then(querySnapshot => {
//       const token =  querySnapshot.docs[0].data().fcmToken;
          
//       const message = {
//       "notification": {
//       title: notificationSenderId,
//       body: notificationMessage
//        }, 
//       token: token}
//       return admin.messaging().send(message);
//     });
//       // data: {click_action: 'FLUTTER_NOTIFICATION_CLICK'}}
//     //sound: 'default'
//   } catch (error) {
//     return console.log(error)
// }
// })

//===================== onUserCreate/onUserUpdate/onPostDelete ========================================

// const db = admin.firestore();
// exports.onUserCreate = functions.firestore.document('users/{userId}').onCreate(async (snap, context) => {
//   const values = snap.data();
//   //send email
//   await db.collection('logging').add({description: `Email was sent to user with username: ${values.username}`});
// });

// exports.onUserUpdate = functions.firestore.document('users/{userId}').onUpdate(async (snap, context) => {
//   const newValues = snap.after.data();
//   const previousValues = snap.before.data();

//   if(newValues.username !== previousValues.username) {
//      const snapshot = await db.collection('reviews').where('username', '==', previousValues.username).get();
//      let updatePromises = [];
//      snapshot.forEach(doc => {
//        updatePromises.push(db.collection('reviews').doc(doc.id).update({username: newValues.username}));
//      });
//      await Promise.all(updatePromises);
//     }
// });

// exports.onPostDelete = functions.firestore.document('posts/{postId}').onDelete(async (snap, context) => {
//    const deletedPost = snap.data();

//    let deletePromises = [];
//    const bucket = admin.storage().bucket();

//    deletedPost.images.forEach(image => {
//      deletePromises.push(bucket.file(image).delete());
//    });
//    await Promise.all(deletePromises);
// });

// =============== cloud functions notif =======================

// var newData;
// exports.messageTrigger = functions.firestore.document('Messages/{messageId}').onCreate(async (snapshot, context) => {
//    if (snapshot.empty) {
//      console.log('no devices'); return;
//    }
//    var tokens = [];
//    newData = snapshot.data();
//    const deviceTokens = await admin.firestore().collection('devicetokens').get();
//    for (var token of deviceTokens.docs) {
//      tokens.push(token.data().device_token);
//    }

//    var payload = {notification: {title: 'push title', body: 'push body', sound: 'default'},
//      data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: newData.message}};
//      try{
//        const response = await admin.messaging().sendToDevice(tokens, payload);
//        console.log('Notification sent successfully');
//      } catch (err) {
//        console.log('Error sending Notification');
//      }
// });

//================ fcmtoken ================================

// exports.sendNotificationToFCMToken = functions.firestore.document('messages/{mUid}').onWrite(async (event) => {
//   const uid = event.after.get('userUid');
//   const title = event.after.get('title');
//   const content = event.after.get('content');
//   let userDoc = await admin.firestore().doc(`users/${uid}`).get();
//   let fcmToken = userDoc.get('fcm');

//   var message = {
//     notification: {title: title, body: content}, token: fcmToken
//   }
//   let response = await admin.messaging().send(message);
//   console.log(response);
  
// });

//====================== notification to nearby users ======================================
// const tokenArray = []
//   const geofireQuery = new GeoFire(admin.database().ref('Geolocations')).query({
//     center: [event._data.location[0].lat, event._data.location[0].lng],
//     radius: event._data.selectedRange
//   })
//   .on('key_entered', async (key) => {
//     // Geofire only provides an index to query.
//     // We'll need to fetch the original object as well
//     const getDeviceTokensPromise = await admin.database()
//     .ref('/UserFCMToken/'+ key ).once('value', (snapShot) => {

//       snapShot.forEach((childSnapshot) => {
//         tokenArray.push(childSnapshot.val().FCMToken)
//                 })
//           })
//     });

//       const response = await admin.messaging().sendToDevice(tokenArray, payload);





//============== pro planet ================================
// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// var GeoFirestore = require('geofirestore').GeoFirestore;
// admin.initializeApp();

// const firestore = admin.firestore();
// const geofirestore = new GeoFirestore(firestore);

// exports.sendNotification = functions.firestore
// .document("crews/{crew}/brews/{brew}")
// .onCreate(async snapshot => {
//     try {const brewfield = snapshot.data().field;
//         const brewaddress = snapshot.data().address;
//         const brewgeopoint = snapshot.data().g.geopoint;

//         const geocollection = geofirestore.collectionGroup('pros');
//         const query = geocollection.near({center: brewgeopoint, radius: 10}).where('field', '==', brewfield);
//         let tokenArray = [];
//         await query.get().then(querySnapshot => {
//             querySnapshot.forEach(doc => {
//                  token = doc.data().fcmToken;
//                 //console.log(token);
//                 tokenArray.push(token);
//             })
//             admin.firestore().doc('pros/{pro}/notifs/{notif}').set({
//                  'address': brewaddress,
//                  });
//             return console.log('tokens pushed')
//             }).catch ((error) =>
//                 console.log(error)
//             );
//             const message = {
//               notification: {
//               title: brewfield,
//               body: brewaddress,
//               sound: 'default'
//             },
//              'data': {
//                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//              }
//             }
//             return admin.messaging().sendToDevice(tokenArray, message);
//             } catch (error) {
//                 console.log(error)
//     }
// })

//================ pro planet modified =============================
const functions = require('firebase-functions');
const admin = require('firebase-admin');
var GeoFirestore = require('geofirestore').GeoFirestore;
const { GeoDocumentSnapshot } = require('geofirestore');

admin.initializeApp();

const firestore = admin.firestore();
const geofirestore = new GeoFirestore(firestore);

exports.sendNotification = functions.firestore
.document("crews/{crew}/brews/{brew}")
.onCreate(async snapshot => {
    try {const brewfield = snapshot.data().field;
        const brewaddress = snapshot.data().address;
        const brewgeopoint = snapshot.data().g.geopoint;

        const geocollection = geofirestore.collectionGroup('pros');
        const query = geocollection.near({center: brewgeopoint, radius: 10}).where('field', '==', brewfield);
        let tokenArray = [];
        await query.get().then( querySnapshot => {
            
            querySnapshot.forEach(async doc => {
                
                 token = doc.data().fcmToken;
                 tokenArray.push(token);
                 console.log(token);
               
                await doc.data().ref.collection('notifs').add({
                    'field': brewfield,
                    'address': brewaddress});
        
                });
                return console.log('collections added');
            }).catch ((error) =>
                console.log(error)
            );
            const message = {
              notification: {
              title: brewfield,
              body: brewaddress,
              sound: 'default'
            },
           'data': {
               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
           }
            }
            return admin.messaging().sendToDevice(tokenArray, message);
            } catch (error) {
                console.log(error)
    }
})