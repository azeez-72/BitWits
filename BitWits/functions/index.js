const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.myTrigger = functions.firestore.document('Announcements/{announcementId}').onCreate(async (snapshot, context) => {
if (snapshot.empty) {
   console.log('No Devices');
   return;
}
var tokens = [];
newData = snapshot.data();
const deviceTokens = await admin.firestore().collection('DeviceTokens').get();

for (var token of deviceTokens.docs) {
    tokens.push(token.data().device_token);
}

var payload = {
notification: {heading : 'New Announcement',body: newData.title ,sound: 'default'},
data: {click_action: 'FLUTTER_NOTIFICATION_CLICK',title: newData.title,},
};

try {
const response = await admin.messaging().sendToDevice(tokens, payload);
console.log('Notification sent successfully');
} catch (err) {
console.log('error sending notification');
}
});
