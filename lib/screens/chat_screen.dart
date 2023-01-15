// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_new/constants.dart';
import 'package:flash_chat_new/utilities/message_stream.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_new/utilities/messaging.dart';

User loggedInUser;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.recipient});
  static const String id = '/chat';
  final String recipient;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textFieldController = TextEditingController();
  String messageText;
  final _auth = FirebaseAuth.instance;
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      loggedInUser = user;
    } catch (e) {
      print(e);
    }
  }

  getMessages() {
    setState(() {
      return MessageStream(loggedInUser, widget.recipient);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(loggedInUser, widget.recipient),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldController.clear();
                      Messaging().sendMessage(
                          loggedInUser, widget.recipient, messageText);
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
