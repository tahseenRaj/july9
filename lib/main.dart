import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:july9/cart.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'forget_password.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//   if (FirebaseAuth.instance.currentUser != null) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Home(),
//     );
//   } else {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Login(),
//     );
//     }
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userStatus = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: userStatus == null ? Home() : Dashboard(),
      routes: {
        '/home':(context) => const Home(),
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/forgetPassword': (context) => const ForgetPassword(),
        '/dashboard': (context) => const Dashboard(),
        '/cart':(context) => const Cart(),
      },
    );
  }
}
