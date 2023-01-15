import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_new/screens/login_screen.dart';
import 'package:flash_chat_new/utilities/convo_stream.dart';
import 'package:flutter/material.dart';
import '../components/new_message_bottomsheet.dart';

class ConvoScreen extends StatefulWidget {
  static const String id = '/conversations';
  const ConvoScreen({Key key}) : super(key: key);

  @override
  State<ConvoScreen> createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  User loggedInUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String searchText;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      loggedInUser = user;
    } catch (e) {
      print('Error Getting Current User: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            NewMessageBottomSheet().createSheet(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton(
                icon: Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text('Logout'),
                      onTap: () {
                        try {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                          _auth.signOut();
                        } catch (e) {
                          print('Signout Error: $e');
                        }
                      },
                    )
                  ];
                })
          ],
          title: Text('⚡️Chat Conversations'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ConvoStream(loggedInUser),
        ),
      ),
    );
  }
}
