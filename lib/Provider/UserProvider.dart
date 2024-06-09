
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Core/firestore_helper.dart';
import '../Model/User.dart'as MyUser;

class UserProvider extends ChangeNotifier{
  User? authUser;
  MyUser.User? databaseUser;

  bool isFirebaseLogedIn(){
    if(FirebaseAuth.instance.currentUser != null){
      authUser = FirebaseAuth.instance.currentUser;
      return true;
    }else{
      return false;
    }
  }

  Future<void> retriveData()async{
    databaseUser = await FireStoreHelper.getUser(authUser!.uid);
  }
}