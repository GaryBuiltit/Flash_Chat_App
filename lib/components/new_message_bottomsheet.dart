import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_new/constants.dart';
import 'package:flash_chat_new/screens/chat_screen.dart';

class NewMessageBottomSheet {
  final searchFieldController = TextEditingController();
  String recipient;
  final _firestore = FirebaseFirestore.instance;

  Future<bool> userExist(String user) async {
    var collection = _firestore.collection('users');
    try {
      var doc = await collection.doc(user).get();
      return doc.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  createSheet(context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        // height: 75,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('To:'),
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: searchFieldController,
                        onChanged: (value) {
                          recipient = value;
                        },
                        decoration: kContactSearchFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        searchFieldController.clear();
                        if (recipient != null &&
                            await userExist(recipient) == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatScreen(recipient: recipient)));
                        }
                        if (recipient == null) {
                          Navigator.pop(context);
                          var registerSnackBar = SnackBar(
                            content:
                                Text('Please provide an email or username!'),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(registerSnackBar);
                        } else if (await userExist(recipient) == false) {
                          Navigator.pop(context);
                          var registerSnackBar = SnackBar(
                            content: Text('No such user found'),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(registerSnackBar);
                        }
                      },
                      child: Text(
                        'Start Chat',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
