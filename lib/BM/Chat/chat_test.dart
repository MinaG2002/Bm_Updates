// ignore_for_file: prefer_const_constructors

import 'package:bmproject/BM/Chat/model/chat_controler.dart';
import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatTest extends StatefulWidget {
  //  static const String screenRoute = 'chat_screen';

  const ChatTest({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatTestState createState() => _ChatTestState();
}

class _ChatTestState extends State<ChatTest> {
  final messagetextcontrollar = TextEditingController();
  final _firestoort = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;
  // late User signedInUser;

  //  String signedInUser = "mina";
  String? massagetext;

  // @override
  // void initState() {
  //   super.initState();
  //  getCurrentUser();
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final name = userProvider.userName;
    Provider.of<ChatControlar>(context, listen: true).fetchchats();
    return Scaffold(
      backgroundColor: Color(0xffd4b083),
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow[900],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 1 - 200,
                  child: Consumer<ChatControlar>(
                    builder: (context, chatControlar, child) {
                      return SafeArea(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: chatControlar.chats.length,
                          itemBuilder: (context, index) {
                            if (name == chatControlar.chats[index].sender) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  left: 8,
                                  top: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      chatControlar.chats[index].sender,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          // BoxShadow(
                                          //   color: Colors.yellow
                                          //       .shade900, // Shadow color with opacity
                                          //   offset: Offset(
                                          //       -1, 1), // Shadow offset
                                          //   blurRadius: 10, // Blur radius
                                          //   spreadRadius: 1, // Spread radius
                                          // ),
                                        ],
                                        color: Color(0xFF9A031E),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          chatControlar.chats[index].text,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  left: 8,
                                  top: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatControlar.chats[index].sender,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: const [
                                          // BoxShadow(
                                          //   color: Colors.grey
                                          //       .shade800, // Shadow color with opacity
                                          //   offset:
                                          //       Offset(2, 2), // Shadow offset
                                          //   blurRadius: 10, // Blur radius
                                          //   spreadRadius: 1, // Spread radius
                                          // ),
                                        ],
                                        color: Color(0Xffe6d3b3),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          chatControlar.chats[index].text,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12),
                color: Color(0xffd4b083),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: Offset(0, 3),
                              blurRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: messagetextcontrollar,
                          onChanged: (value) {
                            massagetext = value;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            hintText: "Write your Message...",
                            border: InputBorder.none,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {
                                  _firestoort.collection("messages").add({
                                    "text": massagetext,
                                    "sender": name,
                                    "time": FieldValue.serverTimestamp(),
                                  });
                                  messagetextcontrollar.clear();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xff9A031E),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // TextButton(
                    //   onPressed: () {
                    //     _firestoort.collection("messages").add({
                    //       "text": massagetext,
                    //       "sender": name,
                    //       "time": FieldValue.serverTimestamp()
                    //     });
                    //     messagetextcontrollar.clear();
                    //   },
                    //   child: Text(
                    //     'send',
                    //     style: TextStyle(
                    //       color: Colors.blue[800],
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 18,
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
