import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_new/components/convo_card.dart';
import 'package:flutter/material.dart';

class ConvoStream extends StatelessWidget {
  ConvoStream(this.loggedInUser);

  final _fireStore = FirebaseFirestore.instance;
  final User loggedInUser;

  @override
  Widget build(BuildContext context) {
    // print(loggedInUser);
    return StreamBuilder(
      stream: _fireStore
          .collection('users')
          .doc(loggedInUser.email)
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        } else {
          final convos = snapshot.data.docs;
          List<ConvoCard> convoCards = [];
          for (var convo in convos) {
            try {
              final converstion = convo.id;
              final newcard = ConvoCard(
                convoParty: converstion,
              );
              convoCards.add(newcard);
            } catch (e) {
              print('ConvoStreamError: $e');
            }
          }
          return GridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            children: convoCards,
          );
        }
      },
    );
  }
}
