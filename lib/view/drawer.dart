

import 'package:chat_app/Helper/login_helper.dart';
import 'package:chat_app/controller/theme_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  User? user;

  MyDrawer({required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool Thememenu=false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xfffbf7ed),
      child: Consumer<ThemeController>(
        builder: (BuildContext context, ThemeController value, Widget? child) {
          return Column(
          children: [
            DrawerHeader(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: (widget.user == null)
                    ? null
                    : (widget.user!.photoURL == null)
                    ? NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHnMRpLGP7It6a6OTGN7Oxq7Hro3LSUwuIrA&s")
                    : NetworkImage("${widget.user!.photoURL}"),
              ),
            ),
            (widget.user == null || widget.user!.displayName == null)
                ? Container()
                : Text(
              "${widget.user!.displayName}",
              style: TextStyle(fontSize: 16),
            ),
            (widget.user == null || widget.user!.email == null)
                ? Container()
                : Text(
              "${widget.user?.email}",
              style: TextStyle(fontSize: 16),
            ),
            ListTile(
              title: Text("Theme",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
              trailing: InkWell(
                  onTap: () {
                    Provider.of<ThemeController>(context,listen: false).setIstheme();
                    setState(() {
                    });
                  },
                  child: Icon((value.IsTheme)?Icons.keyboard_arrow_down:Icons.keyboard_arrow_right)),
            ),
            Visibility(
              visible: value.IsTheme,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      value.settheme(1);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Green ",style: TextStyle(fontSize: 18),),
                        Icon(Icons.square,color: Color(0xff15bd8c),size: 20,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      value.settheme(2);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Blue ",style: TextStyle(fontSize: 18),),
                        Icon(Icons.square,color: Color(0xff318CE7),size: 20,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      value.settheme(3);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pink ",style: TextStyle(fontSize: 18),),
                        Icon(Icons.square,color: Color(0xffFC8CAC),size: 20,)
                      ],
                    ),
                  ),

                ],
              )),
            Spacer(),
            ListTile(
              title: Text("Log Out"),
              trailing: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              tileColor: Colors.redAccent,
              textColor: Colors.white,
              onTap: () async {
                await LoginHelper.loginHelper.signOut();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),
          ],
        );
        },
      ),
    );
  }
}
