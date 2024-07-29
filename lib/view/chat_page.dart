import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chat_app/Helper/firestore_helper.dart';
import 'package:chat_app/Helper/login_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/theme_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  AssetsAudioPlayer sent=AssetsAudioPlayer();
  TextEditingController msgcontrol=TextEditingController();
  TextEditingController updatemsgcontrol=TextEditingController();

  @override
  Widget build(BuildContext context) {
    var Themeint=Provider.of<ThemeController>(context,listen: false).theme;
    String name=ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xfffbf7ed),
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        backgroundColor: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),
        title: Text("${name}",style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: FutureBuilder(future: FirestoreHelper.firestoreHelper.fetchMessages(receiver_id: name), 
                builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("error: ${snapshot.error}"),
                  );
                }
                else{
                  return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, snapshot) {
                    if(snapshot.hasError)
                      {
                        return Center(
                            child: Text("error: ${snapshot.error}"),);
                      }
                    else if(snapshot.hasData)
                      {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        allDocs = (snapshot.data == null) ? [] : snapshot.data!.docs;
                       return (allDocs.isEmpty)?  Align(
                           alignment: Alignment.topCenter,
                           child: Container(child: Image.asset("assets/higif.gif"),)):
                         ListView.builder(
                          reverse: true,
                          itemCount: allDocs.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: (allDocs[index].data()["sent_by"] ==
                                  LoginHelper.loginHelper
                                      .firebaseAuth.currentUser?.email)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 5,left: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 3),
                                        child: CupertinoContextMenu(
                                          actions: [
                                            CupertinoContextMenuAction(
                                                child: Text("Edit"),
                                              onPressed: () async{
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Edit"),
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextFormField(
                                                            controller: updatemsgcontrol,
                                                            decoration: InputDecoration(hintText: "Edit your Message"),

                                                          ),
                                                          SizedBox(height: 15,),
                                                          OutlinedButton(onPressed: () async{
                                                               await FirestoreHelper.firestoreHelper.updateMessage(receiver_id: name, msgDocId: allDocs[index].id, newMessage: updatemsgcontrol.text);
                                                               Navigator.pop(context);
                                                               Navigator.pop(context);
                                                               updatemsgcontrol.clear();
                                                          }, child: Text("Edit"))
                                                        ],
                                                      ),
                                                    );
                                                  },);
                                              },

                                            ),
                                            CupertinoContextMenuAction(
                                              child: Text("Delete",style: TextStyle(color: Colors.red),),
                                              isDefaultAction: true,
                                              onPressed: () async{
                                                await FirestoreHelper.firestoreHelper.deleteMessage(receiver_id: name, msgDocId: allDocs[index].id);
                                                Navigator.pop(context);

                                              },
                                            )
                                          ],
                                          child: Column(
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                child: Container(
                                                  decoration: BoxDecoration(color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),borderRadius: BorderRadius.circular(20)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment: (allDocs[index].data()["sent_by"] ==
                                                          LoginHelper.loginHelper
                                                              .firebaseAuth.currentUser?.email)
                                                          ? CrossAxisAlignment.end
                                                          : CrossAxisAlignment.start,
                                                      children: [
                                                        Text("${allDocs[index].data()["msg"]}",style: TextStyle(fontSize: 17,color: Colors.white),),
                                                        Container(
                                                            child:
                                                        Text("${(allDocs[index].data()["timestamp"] as Timestamp).toDate().hour}:${(allDocs[index].data()["timestamp"] as Timestamp).toDate().minute}",style: TextStyle(fontSize: 10,color: Colors.white60),),),
                                                      ],
                                                    ),
                                                  )),
                                              ),
                                            ],
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            );
                        },);
                      }
                    else{
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },);
                }
              },)
          ),
          Container(
            height: 65,
                      width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: msgcontrol,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(80)
                        ),
                        hintText: "Enter Message"
                      ),

                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                            height: 55,
                      width: 55,
                      decoration: BoxDecoration(color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),shape: BoxShape.circle),
                      child: InkWell(
                          onTap: () async{
                            await sent.open(Audio("assets/notification.mp3"));
                            await FirestoreHelper.firestoreHelper.sendMessage(receiver_id: name, msg: msgcontrol.text);
                            msgcontrol.clear();


                          },
                          child: Icon(Icons.send_rounded,color: Colors.white,)))
                ],
              ),
            ),
                    ),
        ],
      )
    );
  }
}
