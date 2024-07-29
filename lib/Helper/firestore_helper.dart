import 'package:chat_app/Helper/login_helper.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper{
  FirestoreHelper._();
  static final FirestoreHelper firestoreHelper=FirestoreHelper._();
  static final FirebaseFirestore db = FirebaseFirestore.instance;


   Future<void> insertuser({required UserModel userModel}) async{

     DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
     await db.collection("records").doc("users").get();
     Map<String, dynamic>? data = documentSnapshot.data();

     int id=(data==null)?0:data["id"];

     int counter=(data==null)?0:data["counter"];
     
      QuerySnapshot<Map<String,dynamic>>?  querySnapshot= await db.collection("users").get();

      List<QueryDocumentSnapshot<Map<String,dynamic>>> allUserDocs=querySnapshot.docs;

      bool userexist=false;
      int existUserId=0;

      allUserDocs.forEach((QueryDocumentSnapshot<Map<String,dynamic>> snapshot) {
        if(snapshot.data()["email"]==userModel.email)
          {
            userexist=true;
            existUserId=int.parse(snapshot.id);
          }
      });

      if(userexist==false)
        {
          id=id+1;
          await db.collection("users").doc("$id").set(
            {
              "email":userModel.email,
              "auth_id":userModel.auth_uid,
              "created_at":userModel.created_at,
              "logged_in_at":userModel.logged_in_at
            }
          );

          await db.collection("records").doc("users").update({"id":id});
          counter=counter+1;
          await db.collection("records").doc("users").update({"counter":counter});

        }

      if(userexist==true)
        {
          await db.collection("users").doc("$existUserId").update({
            "logged_in_at":DateTime.now()
          }
          );
        }


   }

   // fetch usres
    Stream<QuerySnapshot<Map<String,dynamic>>> fetchAllUser(){
       return db.collection("users").snapshots();
    }

    // ceate chatroom
  Future<void> createChatroom({required String receiver_id}) async {
    await db.collection("chatrooms").doc(receiver_id).set({
      "users": [receiver_id, LoginHelper.loginHelper.firebaseAuth.currentUser?.email]
    });
  }

  //create mssages collection
  Future<void> sendMessage({required String receiver_id, required String msg}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    List<dynamic> users = [];
    String docId = receiver_id;

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_id) &&
          users.contains(LoginHelper.loginHelper.firebaseAuth.currentUser?.email)) {
        docId = doc.id;
      }
    });

    await db.collection("chatrooms").doc(docId).collection("chat").add({
      "msg": msg,
      "sent_by": LoginHelper.loginHelper.firebaseAuth.currentUser!.email,
      "received_by": receiver_id,
      "timestamp": DateTime.now(),
    });
  }


  // fetchmsg
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMessages({required String receiver_id}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    List<dynamic> users = [];
    String docId = "";

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_id) &&
          users.contains(LoginHelper.loginHelper.firebaseAuth.currentUser?.email)) {
        docId = doc.id;
      }
    });

    return db
        .collection("chatrooms")
        .doc(docId)
        .collection("chat")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> deleteMessage({required String receiver_id, required String msgDocId}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    List<dynamic> users = [];
    String docId = receiver_id;

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_id) &&
          users.contains(LoginHelper.loginHelper.firebaseAuth.currentUser?.email)) {
        docId = doc.id;
      }
    });

    await db
        .collection("chatrooms")
        .doc(docId)
        .collection("chat")
        .doc(msgDocId)
        .delete();
  }

  //update msg
  Future<void> updateMessage({required String receiver_id,required String msgDocId,required String newMessage}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    List<dynamic> users = [];
    String docId = receiver_id;

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_id) &&
          users.contains(LoginHelper.loginHelper.firebaseAuth.currentUser?.email)) {
        docId = doc.id;
      }
    });

    await db
        .collection("chatrooms")
        .doc(docId)
        .collection("chat")
        .doc(msgDocId)
        .update({
      "msg": newMessage,
      "sent_by": LoginHelper.loginHelper.firebaseAuth.currentUser?.email,
      "received_by": receiver_id,
    });
  }



}




