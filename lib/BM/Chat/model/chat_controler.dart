import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatControlar extends ChangeNotifier {
  List<CHAT> chats = [];
  List get products => chats;
  Future<void> fetchchats() async {
    try {
      CollectionReference categoryCollection =
          FirebaseFirestore.instance.collection('messages');
      var response =
          await categoryCollection.orderBy("time", descending: true).get();
      chats = response.docs.map((doc) => CHAT.fromFirestore(doc)).toList();

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

class CHAT {
  final String text;
  final String sender;

  CHAT({required this.text, required this.sender});
  //lylhlylhl
  factory CHAT.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    return CHAT(
      text: data['text'] ?? "",
      sender: data['sender'] ?? '',
    );
  }
}
//