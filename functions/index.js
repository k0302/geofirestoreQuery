
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
