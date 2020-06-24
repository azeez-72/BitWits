const functions = require('firebase-functions');

const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.messageTrigger = functions.firestore.document('Classrooms/{classroomId}/Announcements/{announcementId}').onCreate(async (snapshot, context) => {
if (snapshot.empty) {
console.log('No Devices');
return;
}
var tokens =[];
newData = snapshot.data();
const deviceTokens = await admin.firestore().collection('DeviceTokens').get();

for (var token of deviceTokens.docs){
tokens.push(token.data().device_token);
}

var payload = {
  notification: {title: 'New Assignment',sound: 'default'},
  data: {click_action: 'FLUTTER_NOTIFICATION_CLICK', message: newData.message },
};

try {
const response = await admin.messaging().sendToDevice(tokens, payload);
console.log('Notification sent successfully');
} catch (err) {
console.log('error sending notification');
}

});


//  Create and Deploy Your First Cloud Functions
//  https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
//

