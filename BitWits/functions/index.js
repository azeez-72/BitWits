const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('Classrooms/{information}')
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic('announcements',{
      notification:{
        title: '',
        body: '',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        }
      }
    );
 });
