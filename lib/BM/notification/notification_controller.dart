import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String body;
  final DateTime time;

  NotificationItem(
      {required this.title, required this.body, required this.time});
}

class NotificationProvider with ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications.reversed.toList();

  void addNotification(String title, String body) {
    _notifications.add(NotificationItem(
      title: title,
      body: body,
      time: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
