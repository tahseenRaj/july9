import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:july9/product.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final Stream<QuerySnapshot> _cartStream = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart')
      .snapshots();
  num total = 0;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.cyan[400],
          label: Row(
            children: const [
              Text('Proceed to Checkout'),
              SizedBox(width: 30),
              Icon(Icons.arrow_forward_rounded)
            ],
          ), //child widget inside this button
          onPressed: () {
            print("You just checked out! 😎");
            //task to execute when this button is pressed
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyan[800],
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _cartStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 100),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                total += num.parse(data['price']);
                return CartItem(data: data, id: document.reference.id);
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
