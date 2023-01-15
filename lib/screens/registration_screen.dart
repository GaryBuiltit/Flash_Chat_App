import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_new/constants.dart';
import 'package:flash_chat_new/components/rounded_button.dart';
// import 'package:flash_chat_new/screens/chat_screen.dart';
import 'package:flash_chat_new/screens/convos_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = '/registration';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  String email;
  String password;
  String userName;

  creatUser() {
    var docUser = _firestore.collection('users').doc(email.toLowerCase());

    Map<String, dynamic> userJson = {
      'User Name': userName,
      'email': email.toLowerCase(),
      'password': password,
    };

    docUser.set(userJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                // keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userName = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Choose a Username',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.blueAccent,
                label: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (newUser != null) {
                      creatUser();
                      Navigator.pushNamed(context, ConvoScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    var registerSnackBar = SnackBar(
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(registerSnackBar);
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
