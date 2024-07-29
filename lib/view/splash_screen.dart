import 'package:flutter/material.dart';

class Spash extends StatefulWidget {
  const Spash({super.key});

  @override
  State<Spash> createState() => _SpashState();
}

class _SpashState extends State<Spash> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, "/");
    },
    );
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            child: Image.asset("assets/chatlogo.gif",fit: BoxFit.cover,),
          ),
        ),
      ),
    );
  }
}
