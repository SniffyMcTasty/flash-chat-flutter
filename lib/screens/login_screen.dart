import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/rounded_boutton.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/credentials_text_field.dart';
import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    borderSide: Colors.lightBlueAccent,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(
                    height: fScreenHeight(context) * 0.01,
                  ),
                  CredentialsTextField(
                    obscureText: true,
                    hintText: 'Enter your password.',
                    borderSide: Colors.lightBlueAccent,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  SizedBox(
                    height: fScreenHeight(context) * 0.03,
                  ),
                  RoundedButton(
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          Navigator.pushNamed(context, ChatScreen.route);
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                    text: 'Log In',
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
