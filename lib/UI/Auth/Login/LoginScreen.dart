import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms/UI/Home/HomeScreen.dart';
import '../../../Core/DialogUtiles.dart';
import '../../../Core/firebase_error_codes.dart';
import '../../../Core/firestore_helper.dart';
import '../../../Core/validation.dart';
import '../../../Provider/UserProvider.dart';
import '../../../ReusableComponent/CustemTextFormField.dart';
import '../Register/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? passwordController = TextEditingController();

  TextEditingController? emailController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustemTextFormField(
                    decoration: InputDecoration(
                      labelText: "Email :",
                    ),
                    validator: (email) {
                      if (email == null || email.trim().isEmpty)
                        return "Please Enter Vaild Email";
                      Validation.isVaildEmail(email);
                    },
                    controller: emailController,
                  ),
                  CustemTextFormField(
                    decoration: InputDecoration(
                      labelText: "Password :",
                    ),
                    validator: (password) {
                      if (password == null || password.trim().isEmpty)
                        return "Please Enter Vaild Password";
                      Validation.validatePassword(password);
                      if (password.length < 6) {
                        return "Password must be at least 6 characters long";
                      }
                    },
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      isValidate();
                      await login();
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: Text("don't have an account"))
                ],
              ),
            ),
          ),
        ));
  }

  void isValidate() {
    if (formKey.currentState?.validate() == false) {
      return;
    }
  }

  Future <void> login() async{
    try {
      UserProvider provider = Provider.of<UserProvider>(context,listen: false);
      DialogUtiles.showLoadingDialog(context: context);
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController!.text.trim(),
          password: passwordController!.text);
      provider.authUser = credential.user;
      provider.databaseUser = await FireStoreHelper.getUser(credential.user!.uid);
      DialogUtiles.hideDialog(context: context);
      DialogUtiles.showMessageDialog(
        context: context,
        message: 'Login Successfully ${credential.user!.uid}',
        positiveTitle: "ok",
        positiveClick: () {
          DialogUtiles.hideDialog(context: context);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        },
      );
    } on FirebaseAuthException catch (e) {
      DialogUtiles.hideDialog(context: context);
      if (e.code == FirebaseErrorCodes.userNotFound) {
        DialogUtiles.showMessageDialog(
          context: context,
          message: 'No user found for that email.',
          positiveTitle: "ok",
          positiveClick: () {
            DialogUtiles.hideDialog(context: context);
          },
        );
      } else if (e.code == FirebaseErrorCodes.wrongPassword) {
        DialogUtiles.showMessageDialog(
          context: context,
          message: 'Wrong password provided for that user.',
          positiveTitle: "ok",
          positiveClick: () {
            DialogUtiles.hideDialog(context: context);
          },
        );
      }
    }
  }
}
