// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.time});

  final String text;
  final String sender;
  final bool isMe;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: isMe ? Radius.circular(20) : Radius.zero,
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: isMe ? Radius.zero : Radius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
