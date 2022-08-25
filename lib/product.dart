import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class Post extends StatelessWidget {
  final QueryDocumentSnapshot data;
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final db = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart');
  Post({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.white,
      elevation: 3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: GestureDetector(
                child: Image(
                  image: NetworkImage(data.get('url')),
                  // width: 50,
                  height: 100,
                  fit: BoxFit.fill,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(url: data.get('url'));
                  }));
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 0, right: 10, left: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Marquee(
                        text: data.get('title'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        fadingEdgeEndFraction: 0.6,
                        blankSpace: 50.0,
                        velocity: 50.0,
                        pauseAfterRound: const Duration(seconds: 2),
                        // startPadding: 10.0,
                        accelerationDuration: const Duration(seconds: 2),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: const Duration(seconds: 1),
                        decelerationCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(data.get('description'),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 11,
                          ))),
                  const SizedBox(height: 5),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("\$${data.get('price')}",
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        backgroundColor: Colors.cyan[700],
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            var ha = await db.doc(data.id).get();
                            if (ha.exists != true) {
                              print(ha.exists);
                              db.doc(data.id).set({
                                'url': data.get('url').toString(),
                                'title': data.get('title').toString(),
                                'price': data.get('price').toString()
                              }).then((value) {
                                final snackBar = SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text(
                                      '${data.get('title')} is added to your cart.'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            } else {
                              const snackBar = SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text('Already added in your cart.'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // print('Docuement Id: ${data.id}');
                            }
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ))
                ],
              )),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  late String url;
  DetailScreen({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: InteractiveViewer(
            panEnabled: true, // Set it to false
            // minScale: 0.5,
            // maxScale: 2,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Image.network(
                url,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Hero(
          //   tag: 'imageHero',
          //   child: Image.network(
          //     url,
          //   ),
          // ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

// class CartItem extends StatefulWidget {
//   const CartItem({Key? key}) : super(key: key);

//   @override
//   State<CartItem> createState() => _CartItemState();
// }

// class _CartItemState extends State<CartItem> {

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: Row(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(
//               height: 75,
//               width: 75,
//               child: Image(image: NetworkImage('https://cdn.britannica.com/36/167236-050-BF90337E/Ears-corn.jpg')),
//             ),
//             const SizedBox(width: 20),
//             SizedBox(
//               width: 150,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(data['title'], style: const TextStyle(fontSize: 18)),
//                   Text(data['price'], style: const TextStyle(fontSize: 20)),
//                 ],
//               ),
//             ),
//             Positioned(right: 30, child: IconButton(onPressed: () {}, icon: const Icon(Icons.delete)))
//           ],
//         ),
//         ),
//     );
//   }
// }

class CartItem extends StatefulWidget {
  final Map<String, dynamic> data;
  final id;
  const CartItem({
    required this.data, required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late Map<String, dynamic> data;
  static String userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference<Map<String, dynamic>> db = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('cart');
  late int count = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 75,
              width: 75,
              child: Image(image: NetworkImage(widget.data['url'])),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              // width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data['title'],
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text('\$${widget.data['price']}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              count == 1 ? 1 : count--;
                              print(count);
                            });
                          },
                          child: const Icon(
                            Icons.remove_circle_outline,
                            size: 25,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('$count'),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              count++;
                              print(count);
                            });
                          },
                          child: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 25,
                          )),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      db.doc(widget.id)
                      .delete()
                      .then((value) => print("User Deleted"))
                      .catchError((error) => print("Failed to delete user: $error"));
                    });
                    print(widget.id);
                    // print();
                  },
                  icon: const Icon(Icons.delete)),
            )
          ],
        ),
      ),
    );
  }
}
