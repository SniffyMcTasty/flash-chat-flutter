import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../components/rounded_boutton.dart';

class WelcomeScreen extends StatefulWidget {
  static String route = '/';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(
        begin: kBodyText2Color,
        end: Colors.white,
      ),
      duration: Duration(seconds: 1),
      curve: Curves.decelerate,
      builder: (context, Color? color, Widget? child) {
        return Scaffold(
          backgroundColor: color,
          body: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: fScreenHeight(context) * 0.12,
                      width: fScreenHeight(context) * 0.14,
                    ),
                    AnimatedBuilder(
                        animation: CurvedAnimation(
                            parent: animationController..forward(),
                            curve: Curves.elasticInOut),
                        builder: (context, Widget? child) {
                          return Hero(
                            tag: kLogoTag,
                            child: Container(
                              height: animationController.value * 75,
                              child: Image.asset(
                                'images/logo.png',
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                      speed: Duration(milliseconds: 300),
                      cursor: '|',
                    ),
                  ],
                  repeatForever: true,
                  pause: Duration(seconds: 0),
                ),
              ],
            ),
            SizedBox(
              height: fScreenHeight(context) * 0.06,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              text: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.route);
              },
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.route);
              },
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
