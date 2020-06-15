const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
  .document('Classrooms/{information}')
  .onCreate((snapshot, context) => {
    console.log(snapshot.data());
    return;
 });
