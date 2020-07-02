//new code start
import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
// admin.initializeApp(functions.config().functions);

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('Classrooms/{classroomId}/Assignments/{assignmentsId}')
  .onCreate(async snapshot => {
    const class_code = snapshot.data();

    console.log(class_code);

    const payload = admin.messaging.MessagingPayload = {
      notification: {
        title: 'New assignment',
        body: class_code.Title,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };
    return fcm.sendToTopic('assignments',payload);
  });

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


