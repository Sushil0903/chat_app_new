import 'package:chat_app/view/chat_page.dart';
import 'package:chat_app/controller/theme_controller.dart';
import 'package:chat_app/view/home_page.dart';
import 'package:chat_app/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'view/login_page.dart';

void main() async {
  Provider.debugCheckInvalidValueType=null;
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
    return MultiProvider(
      providers: [
        Provider(create: (context) => ThemeController(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: LoginPage();
        initialRoute: "splash_screen",
        routes: {
          "splash_screen":(context) => Spash(),
          "/": (context) => LoginPage(),
          "home_page":(context) => HomePage(),
          "chat_page":(context) => ChatPage(),
        },
      ),
    );
  }
}
