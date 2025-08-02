// // ignore_for_file: prefer_const_constructors

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   static const String screenRoute = 'chat_screen';

//   const ChatScreen({super.key});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _firestoort = FirebaseFirestore.instance;
//   // final _auth = FirebaseAuth.instance;
//   // late User signedInUser;
//   String signedInUser = "essa";
//   String? massagetext;

//   @override
//   void initState() {
//     super.initState();
//     //  getCurrentUser();
//   }

//   // void getCurrentUser() {
//   //   try {
//   //     final user = _auth.currentUser;
//   //     if (user != null) {
//   //       signedInUser = user;
//   //       print(signedInUser.email);
//   //     }
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }
//   // void getmassages() async {
//   //   final massges = await _firestoort.collection("messages").get();
//   //   for (var message in massges.docs) {
//   //     print(message.data());
//   //   }
//   // }
//   void messagestreem() async {
//     await for (var snapshot in _firestoort.collection("messages").snapshots()) {
//       for (var message in snapshot.docs) {
//         print(message.data());
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow[900],
//         title: Row(
//           children: [
//             Image.asset('assets/logo.png', height: 25),
//             SizedBox(width: 10),
//             Text('MessageMe')
//           ],
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               messagestreem();
//               // _auth.signOut();
//               // Navigator.pop(context);
//             },
//             icon: Icon(Icons.downloading),
//           )
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               StreamBuilder<QuerySnapshot>(
//                 stream: _firestoort.collection("messages").snapshots(),
//                 builder: (context, snapshot) {
//                   List<Text> messagewidgets = [];
//                   if (!snapshot.hasData) {
//                     //add here spinner
//                   }
//                   final messaget = snapshot.data!.docs;
//                   for (var message in messaget) {
//                     final messagetext = message.get("text");
//                     final messagesender = message.get("sender");
//                     final messagewidget = Text("$messagetext-$messagesender");
//                     messagewidgets.add(messagewidget);
//                   }
//                   return Column(
//                     children: messagewidgets,
//                   );
//                 },
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border(
//                     top: BorderSide(
//                       color: Colors.orange,
//                       width: 2,
//                     ),
//                   ),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) {
//                           massagetext = value;
//                         },
//                         decoration: InputDecoration(
//                           contentPadding: EdgeInsets.symmetric(
//                             vertical: 10,
//                             horizontal: 20,
//                           ),
//                           hintText: 'Write your message here...',
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         _firestoort.collection("messages").add({
//                           "text": massagetext,
//                           "sender": signedInUser,
//                           "time": FieldValue.serverTimestamp()
//                         });
//                       },
//                       child: Text(
//                         'send',
//                         style: TextStyle(
//                           color: Colors.blue[800],
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
