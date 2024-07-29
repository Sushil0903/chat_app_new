import 'package:chat_app/Helper/firestore_helper.dart';
import 'package:chat_app/Helper/login_helper.dart';
import 'package:chat_app/controller/theme_controller.dart';
import 'package:chat_app/view/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    var Themeint=Provider.of<ThemeController>(context,listen: false).theme;
   User user= ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      backgroundColor: Color(0xfffbf7ed),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),
        title: Text("Chat App",style: TextStyle(color: Colors.white),),
        elevation: 10,
        shadowColor: Colors.grey,
      ),
      drawer: MyDrawer(user: user),
      body: StreamBuilder(stream: FirestoreHelper.firestoreHelper.fetchAllUser(),
        builder: (context, snapshot) {
        if(snapshot.hasError)
          {
            return Center(child: Text("${snapshot.hasError}"),);
          }
        else if(snapshot.hasData)
          {
            QuerySnapshot<Map<String, dynamic>>? querySnapshot = snapshot.data;

            List<QueryDocumentSnapshot<Map<String,dynamic>>> Alluser =
            (querySnapshot != null) ? querySnapshot.docs : [];
            return (Alluser.isEmpty)
                ? Center(child: Text("NO user found"),)
                :ListView.builder(
              itemCount: Alluser.length,
              itemBuilder: (context, index) {
                Timestamp timestamp = Alluser[index].data()["created_at"];
                DateTime dateTime = timestamp.toDate();

                  return (Alluser[index].data()["email"]==LoginHelper.loginHelper.firebaseAuth.currentUser?.email)
                      ?Container()
                      :Padding(
                        padding: const EdgeInsets.only(top: 8,bottom: 5),
                        child: ListTile(
                          leading: CircleAvatar(radius: 25,child: Text("${Alluser[index].data()["email"][0]}".toUpperCase(),style: TextStyle(fontSize: 20),),),
                          title: Text("${Alluser[index].data()["email"]}",style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500),),
                          onTap: () async{
                            await FirestoreHelper.firestoreHelper.createChatroom(receiver_id: Alluser[index].data()["email"]);
                                Navigator.pushNamed(context, "chat_page",arguments: Alluser[index].data()["email"]);
                            },
                        ),
                      );
                },);

          }
        else{
          return Center(child: CircularProgressIndicator(),);
        }


      },),
    );
  }

}
