// ignore_for_file: use_build_context_synchronously, sort_child_properties_last

import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Login/model/login_model.dart';
import 'package:bmproject/BM/Login/model/textfield_wedget.dart';
import 'package:bmproject/BM/Login/view/Login.dart';
import 'package:bmproject/BM/notification/fcm_api.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatAccount extends StatefulWidget {
  const CreatAccount({super.key});

  @override
  State<CreatAccount> createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final ciscoController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordcontroller = TextEditingController();

  bool isLoading = false;
  bool aaaa = true;

  @override
  void dispose() {
    usernameController.dispose();
    ciscoController.dispose();
    phoneController.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print(fcmToken);
    FirebaseMessaging.onBackgroundMessage(handelbackgroundfcm);
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final firestore = FirebaseFirestore.instance;
    final username = usernameController.text.trim();
    final cisco = ciscoController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordcontroller.text.trim();

    try {
      // تحقق من عدم وجود مستخدم بنفس السيسكو
      final existing = await firestore
          .collection('users')
          .where('cisco', isEqualTo: cisco)
          .get();

      if (existing.docs.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('رقم سيسكو مسجل من قبل')));
        setState(() => isLoading = false);
        return;
      }

      // أضف المستخدم الجديد
      final docRef = await firestore.collection('users').add({
        'username': username,
        'cisco': cisco,
        'phone': phone,
        'password': password,
        "Leader": selectedLeader,
        "Manger": selectedManager,
        "Suber": selectedSuperr,
        "Location": selectedlocations,
        "token": fcmToken,
      });

      final user = UserLogin(
        id: docRef.id,
        username: username,
        ciscoNumber: cisco,
        phone: phone,
        password: password,
        leader: "",
        location: '',
        manger: '',
        suber: '',
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب بنجاح')));
      //
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء التسجيل')));
    }

    setState(() => isLoading = false);
  }

  final leader = [
    'Ayman Mohamed',
    'Ahmed Magouri',
    ' Ahmed Douk Hanna',
    "Ahmed Alaa",
    "Abdelrahman Ragab",
  ];

  final superr = [" Mohamed Gaafar"];
  final manager = ["Hesham Amin"];
  final locations = ['Dokki', 'DownTown', ' Nasr City', "October"];
  String? selectedLeader;
  String? selectedSuperr;
  String? selectedManager;
  String? selectedlocations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                const Text(
                  "creat Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Baloo2',
                  ),
                ),
                const Text(
                  "Fill your information below or register",
                  style: TextStyle(fontFamily: "Baloo2"),
                ),
                const Text(
                  "with you social account",
                  style: TextStyle(fontFamily: "Baloo2"),
                ),
                const SizedBox(height: 50),
                CustomTextField(
                  lapel: "your Name ",
                  TextInputTypeee: TextInputType.text,
                  Trueee: false,
                  Hinttexttt: "Enter your Name",
                  controlll: usernameController,
                ),

                const SizedBox(height: 18),
                CustomTextField(
                  lapel: "Cisco Number ",
                  TextInputTypeee: TextInputType.number,
                  Trueee: false,
                  Hinttexttt: "Enter your cisco",
                  controlll: ciscoController,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  lapel: "WhatsApp Number",
                  TextInputTypeee: TextInputType.number,
                  Trueee: false,
                  Hinttexttt: "Enter your Phone Number",
                  controlll: phoneController,
                ),
                const SizedBox(height: 10),
                const Row(children: [Text("Password")]),
                const SizedBox(height: 5),
                TextFormField(
                  validator: (value) => value!.isEmpty ? "Please " : null,
                  textInputAction: TextInputAction.next,
                  controller: passwordcontroller,
                  keyboardType: TextInputType.text,
                  obscureText: aaaa,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        // aaaa = !aaaa;
                        setState(() {
                          aaaa = !aaaa;
                        });
                      },
                      icon: aaaa
                          ? const Icon(
                              Icons.visibility,
                              color: AppTheme.primaryColor,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: AppTheme.primaryColor,
                            ),
                    ),
                    hintText: "************",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: Divider.createBorderSide(context),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 1.5,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 20, bottom: 10),
                  ),
                ),

                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.grey,

                      labelText: "Team Leader",
                      hintText: "Enter your Team Leader",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    items: leader
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => selectedLeader = val as String,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseselectalocation;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.grey,

                      labelText: "Supervisor",
                      hintText: "Enter your Team Supervisor",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    items: superr
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => selectedSuperr = val as String,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseselectalocation;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.grey,

                      labelText: "Team Manger",
                      hintText: "Enter your Team Manger",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    items: manager
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => selectedManager = val as String,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseselectalocation;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // enabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: Colors.grey,

                      labelText: "Enter Location",
                      hintText: "Enter your Location",
                      prefixIcon: const Icon(
                        Icons.person,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    items: locations
                        .map(
                          (loc) =>
                              DropdownMenuItem(value: loc, child: Text(loc)),
                        )
                        .toList(),
                    onChanged: (val) => selectedlocations = val as String,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).Pleaseselectalocation;
                      }
                      return null;
                    },
                  ),
                ),

                //-----------------------------------
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _signup,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 19, color: Colors.white),
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppTheme.primaryColor,
                    ),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                // ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have account?",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'sign in',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
