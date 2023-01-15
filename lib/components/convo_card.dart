import 'package:flash_chat_new/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ConvoCard extends StatelessWidget {
  const ConvoCard({Key key, this.convoParty}) : super(key: key);
  final String convoParty;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(recipient: convoParty)));
          },
          child: Container(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.lightBlueAccent,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    convoParty,
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
