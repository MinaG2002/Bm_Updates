import 'package:bmproject/BM/Home/model/model_updates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// class HomeControl extends ChangeNotifier {
//   List<Updates> updatess = [];
//   List get updates => updatess;
//   Future<void> fetchproducts() async {
//     CollectionReference categoryCollection = FirebaseFirestore.instance
//         .collection('update');
//     var response = await categoryCollection.get();
//     updatess = response.docs.map((doc) => Updates.fromFirestore(doc)).toList();
//     notifyListeners();
//   }
// }
