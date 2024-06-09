import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/UserProvider.dart';
import '../Auth/Login/LoginScreen.dart';
import '../Home/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),() {
      splashFinshed();
    },);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset("assets/images/logo.png"),),
    );
  }

  splashFinshed(){
    UserProvider provider = Provider.of<UserProvider>(context,listen: false);
    if(provider.isFirebaseLogedIn()){
      provider.retriveData();
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }else{
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
