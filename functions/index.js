const functions = require("firebase-functions");

var admin = require("firebase-admin");

var serviceAccount = require("./chat-app-4f142-firebase-adminsdk-efgjv-fcb22def28.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});


exports.createMessage = functions.firestore
  .document('chat/{message}')
  .onCreate((snap, context) => {
    // Get an object representing the document
    // e.g. {'name': 'Marie', 'age': 66}
    const newMessage = snap.data();

    // access a particular field as you would any JS property
    const username = newMessage.username;
    const text = newMessage.text

    // perform desired operations ...
    const topic = 'chat';

    const payload = {
      notification: {
        title: username,
        body: text,

      },
    };



    return admin.messaging().sendToTopic(topic, payload);
  });

