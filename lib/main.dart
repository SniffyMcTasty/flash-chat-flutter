import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: kBodyText2Color),
        ),
      ),
      initialRoute: WelcomeScreen.route,
      routes: {
        WelcomeScreen.route: (context) => WelcomeScreen(),
        ChatScreen.route: (context) => ChatScreen(),
        LoginScreen.route: (context) => LoginScreen(),
        RegistrationScreen.route: (context) => RegistrationScreen(),
      },
    );
  }
}
