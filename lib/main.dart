import 'package:chat_app/chat_page.dart';
import 'package:chat_app/home_page.dart';
import 'package:chat_app/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage();
      initialRoute: "splash_screen",
      routes: {
        "splash_screen":(context) => Spash(),
        "/": (context) => LoginPage(),
        "home_page":(context) => HomePage(),
        "chat_page":(context) => ChatPage(),
      },
    );
  }
}
