import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:udemy_snsapp/utils/authentication.dart';
import 'package:udemy_snsapp/utils/firestore/users.dart';
import 'package:udemy_snsapp/view/screen.dart';
import 'package:udemy_snsapp/view/start_up/create_account_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text('Flutterラボ SNS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'メールアドレス'
                    ),
                  ),
                ),
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: passController,
                  decoration: InputDecoration(
                    hintText: 'パスワード'
                  ),
                ),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(text: 'アカウントを作成していない方は'),
                    TextSpan(text: 'こちら',
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                    }
                    )
                  ]
                ),
              ),
              SizedBox(height: 70),
              ElevatedButton(onPressed: () async {
                var result = await Authentication.emailSignIn(email: emailController.text, pass: passController.text);
                if (result is UserCredential) {
                  var _result = await UserFirestore.getUser(result.user!.uid);
                  if (_result == true) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                  }
                }
              },
                  child: Text('emailでログイン')
              ),
              SignInButton(
                  Buttons.Google,
                  onPressed: () async{
                    var result = await Authentication.signInWithGoogle();
                    if(result is UserCredential){
                      var result = await UserFirestore.getUser(Authentication.currentFirebaseUser!.uid);
                      if(result == true){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Screen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
                      }
                    }
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
