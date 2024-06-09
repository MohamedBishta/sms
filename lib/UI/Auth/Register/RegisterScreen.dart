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
import '../Login/LoginScreen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';
  RegisterScreen({super.key});

  TextEditingController? fullNameController = TextEditingController();

  TextEditingController? emailController = TextEditingController();

  TextEditingController? passwordController = TextEditingController();

  TextEditingController? confirmPasswordController = TextEditingController();

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
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustemTextFormField(
                        decoration: InputDecoration(
                          labelText: "Full Name :",
                        ),
                        validator: (text) {
                          if (text == null || text.trim().isEmpty)
                            return "Please Enter Vaild Name";
                        },
                        controller: fullNameController,
                      ),
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
                          if (password == null || password.isEmpty)
                            return "Please Enter Vaild Password";
                          Validation.validatePassword(password);
                          if (password.length < 6) {
                            return "Password must be at least 6 characters long";
                          }
                        },
                        controller: passwordController,
                      ),
                      CustemTextFormField(
                        decoration: InputDecoration(
                          labelText: "Confirm Password :",
                        ),
                        validator: (confpassword) {
                          if (confpassword == null || confpassword.isEmpty) {
                            return "Please Enter Vaild Password";
                          }
                          else if (confpassword != passwordController!.text) {
                            return "Password doesn't match";
                          }
                          Validation.validatePassword(confpassword);
                        },
                        controller: confirmPasswordController,
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
                          try {
                            UserProvider provider = Provider.of<UserProvider>(context,listen: false);
                            DialogUtiles.showLoadingDialog(context: context);
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailController!.text.trim(),
                              password: passwordController!.text,
                            );
                            provider.authUser = credential.user;
                            MyUser.User databaseUser = MyUser.User(
                              id: credential.user!.uid,
                              name: fullNameController!.text,
                              email: emailController!.text,
                            );
                            provider.databaseUser = databaseUser;
                            await FireStoreHelper.addNewUser(databaseUser);
                            DialogUtiles.hideDialog(context: context);
                            DialogUtiles.showMessageDialog(
                                context: context,
                                message:
                                "Register successfuly ${credential.user!.uid}",
                                positiveTitle: "ok",
                                positiveClick: () {
                                  DialogUtiles.hideDialog(context: context);
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                });
                          } on FirebaseAuthException catch (e) {
                            DialogUtiles.hideDialog(context: context);
                            if (e.code == FirebaseErrorCodes.weakPassword) {
                              DialogUtiles.showMessageDialog(
                                  context: context,
                                  message: "The pas sword provided is too weak.",
                                  positiveTitle: "ok",
                                  positiveClick: () {
                                    DialogUtiles.hideDialog(context: context);
                                  });
                            } else if (e.code == FirebaseErrorCodes.emailExist) {
                              DialogUtiles.showMessageDialog(
                                  context: context,
                                  message:
                                  'The account already exists for that email.',
                                  positiveTitle: "ok",
                                  positiveClick: () {
                                    DialogUtiles.hideDialog(context: context);
                                  });
                            }
                          } catch (e) {
                            DialogUtiles.hideDialog(context: context);
                            DialogUtiles.showMessageDialog(
                                context: context,
                                message: e.toString(),
                                positiveTitle: "ok",
                                positiveClick: () {
                                  DialogUtiles.hideDialog(context: context);
                                });
                          }
                        },
                        child: Text(
                          "Create Account",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.routeName);
                          },
                          child: Text("Already have an account"))
                    ],
                  ),
                ),
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
}
