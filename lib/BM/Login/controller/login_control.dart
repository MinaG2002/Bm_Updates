import 'package:bmproject/BM/Login/model/login_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  UserLogin? _currentUser;
  UserLogin? get currentUser => _currentUser;

  String? userName;
  String? userCisco;
  String? userphone;
  String? userleader;
  String? userlocation;
  String? usermanager;
  String? usersuper;
  // String? userpassword;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> login(String cisco, String password) async {
    final result = await _firestore
        .collection('users')
        .where('cisco', isEqualTo: cisco)
        .where('password', isEqualTo: password)
        .get();

    if (result.docs.isNotEmpty) {
      final doc = result.docs.first;
      _currentUser = UserLogin.fromMap(doc.id, doc.data());

      userCisco = _currentUser?.ciscoNumber;
      userName = _currentUser?.username;
      userphone = _currentUser?.phone;
      userleader = _currentUser?.leader;
      userlocation = _currentUser?.location;
      usermanager = _currentUser?.manger;
      usersuper = _currentUser?.suber;

      //  تخزين البيانات محليًا
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userCisco', userCisco!);
      await prefs.setString('userName', userName!);
      await prefs.setString('Leader', userleader!);
      await prefs.setString('Location', userlocation!);
      await prefs.setString('Manger', usermanager!);
      await prefs.setString('Suber', usersuper!);
      await prefs.setString('phone', userphone!);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setUser(UserLogin user) async {
    _currentUser = user;
    userCisco = user.ciscoNumber;
    userName = user.username;
    userphone = user.phone;
    userleader = user.leader;
    userlocation = user.location;
    usermanager = user.manger;
    usersuper = user.suber;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userCisco', userCisco!);
    await prefs.setString('userName', userName!);
    await prefs.setString('Leader', userleader!);
    await prefs.setString('Location', userlocation!);
    await prefs.setString('Manger', usermanager!);
    await prefs.setString('Suber', usersuper!);
    await prefs.setString('phone', userphone!);

    notifyListeners();
  }

  void logout() async {
    _currentUser = null;
    userCisco = null;
    userName = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userCisco');
    await prefs.remove('userName');
    await prefs.remove('Leader');
    await prefs.remove('Location');
    await prefs.remove('Suber');
    await prefs.remove('phone');
    await prefs.remove('Manger');

    notifyListeners();
  }

  // ✅ تحميل البيانات عند فتح التطبيق
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userCisco = prefs.getString('userCisco');
    userName = prefs.getString('userName');
    userleader = prefs.getString('Leader');
    userlocation = prefs.getString('Location');
    usersuper = prefs.getString('Suber');
    userphone = prefs.getString('phone');
    usermanager = prefs.getString('Manger');

    // هنا يمكنك جلب باقي بيانات المستخدم من Firebase لو حبيت
    if (userCisco != null && userName != null) {
      notifyListeners();
    }
  }

  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == "ar";

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('ar');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
