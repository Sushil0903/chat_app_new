

import 'package:chat_app/Helper/login_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  User? user;

  MyDrawer({required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
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
      ),
    );
  }
}
