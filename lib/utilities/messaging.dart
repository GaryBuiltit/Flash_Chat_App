import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messaging {
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void sendMessage(User loggedInUser, String recipient, String messageText) {
    var senderMessageCollection = _fireStore
        .collection('users')
        .doc(loggedInUser.email)
        .collection('messages')
        .doc(recipient);

    var recipientMessageCollection = _fireStore
        .collection('users')
        .doc(recipient)
        .collection('messages')
        .doc(loggedInUser.email);

    Map message = {
      'sender': loggedInUser.email,
      'recipient': recipient,
      'message': messageText,
      'time': DateTime.now(),
    };

    senderMessageCollection
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      var updatedMessages = [];
      Map<String, dynamic> messageDoc = {'messages': updatedMessages};
      if (!documentSnapshot.exists) {
        updatedMessages.add(message);
        senderMessageCollection.set(messageDoc);
      } else {
        try {
          var messagesDoc = await senderMessageCollection.get();
          var messageList = messagesDoc['messages'];
          for (var messageData in messageList) {
            var oldMessage = messageData as Map;
            updatedMessages.add(oldMessage);
          }
          updatedMessages.add(message);
          senderMessageCollection.set(messageDoc);
        } catch (e) {
          print('SenderMessageError: $e');
        }
      }
    });

    recipientMessageCollection
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      var updatedMessages = [];
      Map<String, dynamic> messageDoc = {'messages': updatedMessages};
      if (!documentSnapshot.exists) {
        updatedMessages.add(message);
        recipientMessageCollection.set(messageDoc);
      } else {
        try {
          var messagesDoc = await recipientMessageCollection.get();
          var messageList = messagesDoc['messages'];
          for (var messageData in messageList) {
            var oldMessage = messageData as Map;
            updatedMessages.add(oldMessage);
          }
          updatedMessages.add(message);
          recipientMessageCollection.set(messageDoc);
        } catch (e) {
          print('RecipientMessageError: $e');
        }
      }
    });
  }
}
