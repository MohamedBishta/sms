import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Core/DialogUtiles.dart';
import '../Auth/Login/LoginScreen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMSعراق",textAlign: TextAlign.center),actions: [
          IconButton(
            onPressed: () {
              DialogUtiles.showMessageDialog(
                context: context,
                message: "Are you Sure you Want to Loged out",
                positiveTitle: "Ok",
                positiveClick: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
                negativeTitle: "Cancel",
                negativeClick: (){
                  Navigator.pop(context);
                },
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              size: 20,
            ),
            color: Colors.white,
          )
        ],),
    );
  }
}
