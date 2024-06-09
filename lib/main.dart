import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms/Provider/UserProvider.dart';
import 'package:sms/UI/Auth/Login/LoginScreen.dart';
import 'package:sms/UI/Auth/Register/RegisterScreen.dart';
import 'package:sms/UI/Home/HomeScreen.dart';
import 'package:sms/UI/Splash/SplashScreen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(create: (BuildContext context)=> UserProvider(),
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          toolbarHeight: 100,
            color: Colors.blue,titleTextStyle:TextStyle(color: Colors.white,fontSize: 24)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName : (_)=> SplashScreen(),
        LoginScreen.routeName : (_)=> LoginScreen(),
        RegisterScreen.routeName : (_)=> RegisterScreen(),
        HomeScreen.routeName : (_)=> HomeScreen()
      },
    );
  }
}
