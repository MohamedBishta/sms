import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Core/DialogUtiles.dart';
import '../../../Core/firebase_error_codes.dart';
import '../../../Core/firestore_helper.dart';
import '../../../Core/validation.dart';
import '../../../Provider/UserProvider.dart';
import '../../../ReusableComponent/CustemTextFormField.dart';
import '../../Home/HomeScreen.dart';
import '../Register/RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'login';
  LoginScreen({super.key});
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    UserProvider provider =Provider.of<UserProvider>(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustemTextFormField(decoration:  InputDecoration(label:Text("Email :") ), controller: emailController, validator: (text) {
                  if(text == null || text.trim().isEmpty){
                    return "Please Enter your Email ";
                  }
                  if(!Validation.isVaildEmail(text)){
                    return "Please Enter Valid Email";
                  }
                },),
                CustemTextFormField(decoration:  InputDecoration(label:Text("Password :") ), controller: passwordController, validator: (text) {
                  if(text == null || text.isEmpty){
                    return "Please Enter Password";
                  }
                  if(text!.length < 6){
                    return 'Please Enter Strong Password';
                  }
                },),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateProperty.all(Colors.blue)),
                    onPressed: () async {
                      validation();
                      try {
                        DialogUtiles.showLoadingDialog(context: context);
                        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailController!.text.trim(),
                          password: passwordController!.text,
                        );
                        provider.authUser = credential.user;
                        provider.databaseUser = await FireStoreHelper.getUser(credential.user!.uid);
                        DialogUtiles.hideDialog(context: context);
                        DialogUtiles.showMessageDialog(context: context, message: "Login Successfuly",positiveTitle: "ok",
                            positiveClick: () {
                              DialogUtiles.hideDialog(context: context);
                              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                            });
                      } on FirebaseAuthException catch (e) {
                        DialogUtiles.hideDialog(context: context);
                        if (e.code == FirebaseErrorCodes.userNotFound) {
                          DialogUtiles.showMessageDialog(context: context, message: "No user found for that email.",positiveTitle: "ok");
                        } else if (e.code == FirebaseErrorCodes.wrongPassword) {
                          DialogUtiles.showMessageDialog(context: context, message: "Wrong password provided for that user.",positiveTitle: "ok");
                        }
                      }
                    }, child: Text("Login",style: TextStyle(color: Colors.white),)),
                TextButton(onPressed: () {
                  Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                }, child: Text("don't have account?"))
              ],),
          ),
        ),
      ),
    );
  }
  void validation(){
    if(formKey.currentState?.validate() == false){
      return ;
    }
  }
}
