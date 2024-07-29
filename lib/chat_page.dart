import 'package:chat_app/Helper/firestore_helper.dart';
import 'package:chat_app/Helper/login_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController msgcontrol=TextEditingController();
  TextEditingController updatemsgcontrol=TextEditingController();

  @override
  Widget build(BuildContext context) {
    String name=ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      backgroundColor: Color(0xfffbf7ed),
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.grey,
        backgroundColor: Color(0xff15bd8c),
        title: Text("${name}",style: TextStyle(color: Colors.white),),
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
                  return StreamBuilder(stream: snapshot.data, builder: (context, snapshot) {
                    if(snapshot.hasError)
                      {
                        return Center(
                            child: Text("error: ${snapshot.error}"),);
                      }
                    else if(snapshot.hasData)
                      {
                        List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        allChat = (snapshot.data == null) ? [] : snapshot.data!.docs;
                        return ListView.builder(
                          reverse: true,
                          itemCount: allChat.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: (allChat[index].data()["sent_by"] ==
                                  LoginHelper.loginHelper
                                      .firebaseAuth.currentUser?.email)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Column(
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
                                                             await FirestoreHelper.firestoreHelper.updateMessage(receiver_id: name, msgDocId: allChat[index].id, newMessage: updatemsgcontrol.text);
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
                                              await FirestoreHelper.firestoreHelper.deleteMessage(receiver_id: name, msgDocId: allChat[index].id);
                                              Navigator.pop(context);

                                            },
                                          )
                                        ],
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            decoration: BoxDecoration(color: Color(0xff15bd8c),borderRadius: BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text("${allChat[index].data()["msg"]}",style: TextStyle(fontSize: 15,color: Colors.white),),
                                            )),
                                        ),
                                      ),
                                    ),


                                  ],
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
          Expanded(
              flex: 1,
              child: Container(
            width: double.infinity,
            color: Colors.transparent,
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
                          decoration: BoxDecoration(color: Color(0xff15bd8c),shape: BoxShape.circle),
                          child: InkWell(
                              onTap: () async{
                                await FirestoreHelper.firestoreHelper.sendMessage(receiver_id: name, msg: msgcontrol.text);
                                msgcontrol.clear();

                              },
                              child: Icon(Icons.send_rounded)))
                    ],
                  ),
                ),
          )),
        ],
      )
    );
  }
}
