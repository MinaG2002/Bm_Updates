import 'package:bmproject/BM/Swap/model/request_swa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<RequestModel> _requests = [];

  List<RequestModel> get requests => _requests;

  Future<void> fetchRequests() async {
    final snapshot = await _firestore.collection('requests').get();
    _requests = snapshot.docs
        .map((doc) => RequestModel.fromMap(doc.id, doc.data()))
        .toList();
    notifyListeners();
  }

  Future<void> addRequest(RequestModel request) async {
    final docRef = await _firestore.collection('requests').add(request.toMap());
    _requests.add(
      RequestModel(
        id: docRef.id,
        name: request.name,
        ciscoNumber: request.ciscoNumber,
        location: request.location,
        phone: request.phone,
        requestType: request.requestType,
        date: request.date,
        notes: request.notes,
      ),
    );
    notifyListeners();
  }

  List<RequestModel> filterByLocation(String location) {
    return _requests.where((req) => req.location == location).toList();
  }
}
