import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              backgroundColor: Colors.transparent,
              content: SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator())),
            );
          });
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await FirebaseAuth.instance.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null) {
        db.collection('users').doc(user.uid).set({
          'userName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
        });
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 100),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.6,
            child: const Image(image: AssetImage('assets/images/home.gif')),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[50]),
                        overlayColor:
                            MaterialStateProperty.all(Colors.blue[200]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        // onPrimary: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 20),
                          Icon(
                            Icons.mail_outlined,
                            color: Colors.green,
                            size: 25,
                          ),
                          SizedBox(width: 50),
                          Text('Login with Email',
                              style: TextStyle(fontSize: 16)),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[50]),
                        overlayColor:
                            MaterialStateProperty.all(Colors.blue[200]),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      child: Row(
                        children: const [
                          SizedBox(width: 20),
                          Image(
                            image: NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/800px-Google_%22G%22_Logo.svg.png'),
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 50),
                          Text('Login with Google',
                              style: TextStyle(fontSize: 16)),
                        ],
                      )),
                ),
                
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
