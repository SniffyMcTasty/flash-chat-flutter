import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/credentials_text_field.dart';
import 'package:flash_chat/components/rounded_boutton.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';

class RegistrationScreen extends StatefulWidget {
  static String route = '/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: kLogoTag,
                    child: Container(
                      height: fScreenHeight(context) * 0.25,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: fScreenHeight(context) * 0.08,
                  ),
                  CredentialsTextField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                    borderSide: Colors.blueAccent,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: fScreenHeight(context) * 0.01,
                  ),
                  CredentialsTextField(
                    obscureText: true,
                    hintText: 'Enter your password',
                    borderSide: Colors.blueAccent,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: fScreenHeight(context) * 0.03,
                  ),
                  RoundedButton(
                    color: Colors.blueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          Navigator.pushNamed(context, ChatScreen.route);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    text: 'Register',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
