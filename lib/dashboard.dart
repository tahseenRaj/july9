import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'product.dart';
import 'main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final user = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference db = FirebaseFirestore.instance.collection('users');
  late Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  bool sortA = true;
  bool sort$ = true;

  signout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.cyan[800],
          title: const Text(
            'Dashboard',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      sortA = !sortA;
                      _usersStream = FirebaseFirestore.instance
                          .collection('products')
                          .orderBy('title', descending: sortA)
                          .snapshots();
                    });
                  },
                  icon: const Icon(Icons.sort_by_alpha)),
            ),
            Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      sort$ = !sort$;
                      _usersStream = FirebaseFirestore.instance
                          .collection('products')
                          .orderBy("price", descending: sort$)
                          .snapshots();
                    });
                  },
                  icon: const Icon(Icons.price_change),
                ))
          ],
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: FutureBuilder<DocumentSnapshot>(
            future: db.doc(user).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Center(child: CircularProgressIndicator(),);
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(data['photoUrl']),
                            backgroundColor: Colors.cyan[50],
                            radius: 40,
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                              child: Text(
                            data['userName'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan[800]),
                          )),
                          const SizedBox(height: 5),
                          Flexible(
                              child: Text(
                            data['email'],
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.cyan[800],
                                letterSpacing: 1),
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: Colors.cyan[50],
                        leading: Icon(
                          Icons.home_rounded,
                          color: Colors.cyan[800],
                        ),
                        title: Text('Home',
                            style: TextStyle(
                                color: Colors.cyan[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: Colors.cyan[50],
                        leading: Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.cyan[800],
                        ),
                        title: Text('Cart',
                            style: TextStyle(
                                color: Colors.cyan[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onTap: () {
                          Navigator.pushNamed(context, '/cart');
                          Timer(const Duration(milliseconds: 50), () {
                            Scaffold.of(context).closeDrawer();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        tileColor: Colors.cyan[50],
                        leading: Icon(
                          Icons.logout_rounded,
                          color: Colors.cyan[800],
                        ),
                        title: Text('Logout',
                            style: TextStyle(
                                color: Colors.cyan[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        onTap: () {
                          signout();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return OrientationBuilder(builder: (context, orientation) {
                      return GridView.builder(
                          dragStartBehavior: DragStartBehavior.start,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10),
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 4,
                                  childAspectRatio:
                                      orientation == Orientation.portrait
                                          ? 0.67
                                          : 0.7,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            QueryDocumentSnapshot<Object?> data =
                                snapshot.data!.docs[index];
                            return Post(data: data);
                          });
                    });
                  },
                ))));
  }
}
