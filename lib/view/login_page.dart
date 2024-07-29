import 'package:chat_app/Helper/login_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Helper/firestore_helper.dart';
import '../Model/user_model.dart';
import '../controller/theme_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController signupcontrol =TextEditingController();
  TextEditingController signuppasswordcontrol =TextEditingController();

  TextEditingController signInpasswordcontrol =TextEditingController();
  TextEditingController signIncontrol =TextEditingController();
  @override
  Widget build(BuildContext context) {
    var Themeint=Provider.of<ThemeController>(context,listen: false).theme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // color: Colors.red,
                width: double.infinity,
                child: Image.network("https://cdn.dribbble.com/users/603698/screenshots/4118380/chat-icon.gif",fit: BoxFit.cover,),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                // color: Colors.cyanAccent,
                color: Color(0xfffbf7ed),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          controller: signIncontrol,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined,color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),),hintText: "Enter Email",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          controller: signInpasswordcontrol,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.password,color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),),hintText: "Enter Password",border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                  
                        ),
                      ),
                     SizedBox(height: 20,),
                     InkWell(
                       onTap: ()async
                       {
                         Map<String,dynamic> res=await LoginHelper.loginHelper.signIn(email: signIncontrol.text, password: signInpasswordcontrol.text);
                  
                         if(res["user"]!=null)
                         {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text("Sign In Successfully "),
                               backgroundColor: Colors.green,
                               behavior: SnackBarBehavior.floating,
                             ),
                           );
                  
                           User user=res["user"];
                           UserModel userModel=UserModel(email: user.email!, auth_uid: user.uid, created_at: DateTime.now());
                  
                  
                           await FirestoreHelper.firestoreHelper.insertuser(userModel: userModel);
                           Navigator.pushReplacementNamed(context, "home_page",arguments: res["user"]);
                           signIncontrol.clear();
                           signInpasswordcontrol.clear();
                         }
                         else if(res["error"]!=null)
                         {
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text(res["error"]),
                               backgroundColor: Colors.redAccent,
                               behavior: SnackBarBehavior.floating,
                             ),
                           );
                         }
                         else{
                           ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(
                               content: Text("Something went wrong"),
                               backgroundColor: Colors.redAccent,
                               behavior: SnackBarBehavior.floating,
                             ),
                           );
                         }
                  
                       },
                       child: Container(
                         height: 50,
                         width: 300,
                         child: Center(child: Text("Log In",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
                         decoration: BoxDecoration(color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),borderRadius: BorderRadius.circular(30)),
                       ),
                     ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: () async
                        {
                          Map<String, dynamic> res =
                          await LoginHelper.loginHelper.signInWithGoogle();
                          if (res["user"] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("User Sign In Successfully"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                  
                            User user = res["user"];
                  
                            UserModel userModel = UserModel(
                              email: user.email!,
                              auth_uid: user.uid,
                              created_at: DateTime.now(),
                              logged_in_at: DateTime.now(),
                            );
                  
                            await FirestoreHelper.firestoreHelper
                                .insertuser(userModel: userModel);
                  
                  
                            Navigator.of(context)
                                .pushReplacementNamed("home_page", arguments: res["user"]);
                          }
                          else if (res["error"] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(res["error"]),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Somethin went wrong"),
                                backgroundColor: Colors.redAccent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          child: Center(child: Text("Sign In with Google",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),),
                          decoration: BoxDecoration(color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dont have an Account? ",style: TextStyle(fontSize: 15),),
                          InkWell(
                              onTap: () {
                                ButtonSignup();
                              },
                              child: Text(" Sign Up",style: TextStyle(color: (Themeint==1)?Color(0xff15bd8c):(Themeint==2)?Color(0xff318CE7):Color(0xffFC8CAC),fontSize: 15,fontWeight: FontWeight.w500),)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonSignup()
  {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Sign Up"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: signupcontrol,
              decoration: InputDecoration(hintText: "Enter Email",border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: signuppasswordcontrol,
              decoration: InputDecoration(hintText: "Enter Password",border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            OutlinedButton(onPressed: () async{
              Map<String,dynamic>res= await LoginHelper.loginHelper.signup(email: signupcontrol.text, password: signuppasswordcontrol.text);
              if (res["user"] != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User Sign Up Successfully..."),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                User user = res["user"];

                UserModel userModel = UserModel(
                    email: user.email!,
                    auth_uid: user.uid,
                    created_at: DateTime.now());

                // call the insertUser()
                await FirestoreHelper.firestoreHelper
                    .insertuser(userModel: userModel);
              }
              else if(res["error"]!=null)
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(res["error"]),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("User Sign Up failed "),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              signupcontrol.clear();
              signuppasswordcontrol.clear();
            }, child: Text("Sign Up")),
          ],
        ),
      );
    },);
  }
  BottonSignin()
  {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Sign In"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: signIncontrol,
              decoration: InputDecoration(hintText: "Enter Email",border: OutlineInputBorder()),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: signInpasswordcontrol,
              decoration: InputDecoration(hintText: "Enter Password",border: OutlineInputBorder()),

            ),
            SizedBox(height: 20,),
            OutlinedButton(onPressed: () async
            {
              Map<String,dynamic> res=await LoginHelper.loginHelper.signIn(email: signIncontrol.text, password: signInpasswordcontrol.text);

                  if(res["user"]!=null)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Sign In Successfully "),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );

                      User user=res["user"];
                      UserModel userModel=UserModel(email: user.email!, auth_uid: user.uid, created_at: DateTime.now());


                      await FirestoreHelper.firestoreHelper.insertuser(userModel: userModel);
                      Navigator.pushReplacementNamed(context, "home_page",arguments: res["user"]);
                      signIncontrol.clear();
                      signInpasswordcontrol.clear();
                    }
                  else if(res["error"]!=null)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(res["error"]),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Something went wrong"),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }

            }, child: Text("Sign In")),
          ],
        ),
      );
    },);

  }
}


