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
      Duration(seconds: 3), () {
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
        child: Image.network("https://mir-s3-cdn-cf.behance.net/project_modules/hd/b9909870073885.5b9763b13f233.gif",fit: BoxFit.fill,),
      ),
    );
  }
}
