import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Core/DialogUtiles.dart';
import '../../../Core/firebase_error_codes.dart';
import '../../../Core/firestore_helper.dart';
import '../../../Core/validation.dart';
import '../../../Model/User.dart' as MyUser;
import '../../../Provider/UserProvider.dart';
import '../../../ReusableComponent/CustemTextFormField.dart';
import '../../Home/HomeScreen.dart';
import '../Login/LoginScreen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';
  RegisterScreen({super.key});

  TextEditingController? nameController = TextEditingController();

  TextEditingController? emailController = TextEditingController();

  TextEditingController? passwordController = TextEditingController();

  TextEditingController? confirmPassController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context);
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
                CustemTextFormField(decoration:  InputDecoration(label:Text("Full Name :") ), controller: nameController, validator: (text) {
                  if(text == null || text.trim().isEmpty){
                    return "Please Enter your Name ";
                  }
                },),
                CustemTextFormField(decoration:  InputDecoration(label:Text("Email :") ), controller: emailController, validator: (text) {
                  if(text == null || text.trim().isEmpty){
                    return "Please Enter your Email ";
                  }
                  if(!Validation.isVaildEmail(text)){
                    return "Please Enter Valid Email";
                  }
                },),
                CustemTextFormField(decoration:  InputDecoration(label:Text("Password :") ), controller: passwordController, validator: (text) {
                  if(text == null || text.trim().isEmpty){
                    return "Please Enter Password";
                  }
                },),
                CustemTextFormField(decoration:  InputDecoration(label:Text("Confirm Password") ), controller: confirmPassController, validator: (text) {
                  if(text == null || text.trim().isEmpty){
                    return "Please Enter Confirmation Password";
                  }
                  if(passwordController?.text != text){
                    return "Please Enter The same Password";
                  }
                },),
                SizedBox(height: 15,),
                ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateProperty.all(Colors.blue)),
                    onPressed: () async {
                      validation();
                      try {
                        DialogUtiles.showLoadingDialog(context: context);
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController!.text.trim(),
                          password: passwordController!.text,
                        );
                        provider.authUser = credential.user;
                        MyUser.User databaseUser = MyUser.User(
                          id: credential.user!.uid,
                          name: nameController!.text,
                          email : emailController!.text,
                        );
                        provider.databaseUser = databaseUser;
                        await FireStoreHelper.addNewUser(databaseUser);
                        DialogUtiles.hideDialog(context: context);
                        DialogUtiles.showMessageDialog(context: context, message: "Registered Successfuly",positiveTitle: "ok",
                            positiveClick: (){
                              DialogUtiles.hideDialog(context: context);
                              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                            });
                      } on FirebaseAuthException catch (e) {
                        DialogUtiles.hideDialog(context: context);
                        if (e.code == FirebaseErrorCodes.weakPassword) {
                          DialogUtiles.showMessageDialog(context: context, message: "The password provided is too weak.",positiveTitle: "ok");
                        } else if (e.code == FirebaseErrorCodes.emailExist) {
                          DialogUtiles.showMessageDialog(context: context, message: "The account already exists for that email.",positiveTitle: "ok");
                        }
                      } catch (e) {
                        DialogUtiles.showMessageDialog(context: context, message: e.toString(),positiveTitle: "ok");
                      }
                    }, child: Text("Create Account",style: TextStyle(color: Colors.white),)),
                TextButton(onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                }, child: Text("Already have account?"))
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
