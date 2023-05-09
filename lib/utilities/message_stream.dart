import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:intl/intl.dart';

class MessageStream extends StatelessWidget {
  MessageStream(this.loggedInUser, this.recipient);

  final _fireStore = FirebaseFirestore.instance;
  final User loggedInUser;
  final String recipient;
  final DateFormat _dateFormat = DateFormat('EEE, MMM d hh:mm aaa');

  @override
  Widget build(BuildContext context) {
    List<MessageBubble> messageBubbles = [];
    return StreamBuilder(
      stream: _fireStore
          .collection('users')
          .doc(loggedInUser.email)
          .collection('messages')
          .doc(recipient)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        } else {
          try {
            var messageData = snapshot.data;
            var messages = messageData['messages'];
            messageBubbles.clear();
            for (var message in messages) {
              final messageText = message['message'];
              final messageSender = message['sender'];
              final firebaseTime = DateFormat('yyyy-MM-d hh:mm:ss.sss')
                  .parse(message['time'].toDate().toString());
              final messageDateTime = _dateFormat.format(firebaseTime);
              var newBubble = MessageBubble(
                sender: messageSender,
                text: messageText,
                isMe: messageSender == loggedInUser.email,
                time: messageDateTime,
              );
              messageBubbles.insert(0, newBubble);
            }
          } catch (e) {
            print('MessageStreamError: $e');
          }
        }
        return Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: messageBubbles.length,
            itemBuilder: (context, index) {
              return messageBubbles[index];
            },
          ),
        );
      },
    );
  }
}
