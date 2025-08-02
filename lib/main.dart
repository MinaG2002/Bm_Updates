import 'dart:io';

import 'package:bmproject/BM/Chat/model/chat_controler.dart';
import 'package:bmproject/BM/Login/controller/login_control.dart';
import 'package:bmproject/BM/Login/view/Login.dart';
import 'package:bmproject/BM/Swap/controller/con_swap.dart';
import 'package:bmproject/BM/nav_bar/controller/nav_control.dart';
import 'package:bmproject/BM/nav_bar/view/nav_bar.dart';
import 'package:bmproject/BM/notification/fcm_api.dart';
import 'package:bmproject/BM/notification/notification_controller.dart';
import 'package:bmproject/firebase_options.dart';
import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  const String currentAppVersion = "4.1.3";
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmApi().iniNotification();
  String? latestVersion = await fetchLatestVersion();
  runApp(MyApp(isUpToDate: latestVersion == currentAppVersion));
}

Future<String?> fetchLatestVersion() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('updateapp')
        .doc(
          'version',
        ) // هنا تأكد ما هو اسم الـ Document لديك (إذا هو ID عشوائي راجعه)
        .get();
    if (snapshot.exists) {
      return snapshot['version']; // تأكد من اسم الحقل الصحيح
    }
    return null;
  } catch (e) {
    return null;
  }
}

class MyApp extends StatelessWidget {
  final bool isUpToDate;
  const MyApp({super.key, required this.isUpToDate});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //  ChangeNotifierProvider(create: (context) => HomeControl()),
        ChangeNotifierProvider(create: (context) => ChatControlar()),
        // ChangeNotifierProvider(create: (context) => AllControl()),
        ChangeNotifierProvider(create: (context) => NavControl()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => RequestProvider()),
      ],
      child: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return FutureBuilder(
            future: userProvider.loadUser(),
            builder: (context, snapshot) {
              return MaterialApp(
                locale: userProvider.locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.theme,
                home: isUpToDate
                    ? userProvider.userCisco != null
                          ? const CustomNavBarBM()
                          : const LoginPage()
                    : UpdateRequiredScreen(),
                // LoginPage(),
                // CustomNavBar(),
              );
            },
          );
        },
      ),
    );
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.manage_history_sharp,
              color: AppTheme.primaryColor,
              size: 150,
            ),
            Text(
              "Update Avilable",
              style: TextStyle(
                color: AppTheme.textPrimaryColor,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "A new version of the app is",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " available. Please update to get",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " the latest features and ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "performance improvements.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 20,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text('Later'),
                ),
                ElevatedButton(
                  onPressed: _openWhatsAppAdmin,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppTheme.primaryColor,
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.only(left: 20, right: 20),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text(
                    "Update Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

void _openWhatsAppAdmin() async {
  print(Uri);
  final message = Uri.encodeComponent("I need Latest Version Bm Updates app");
  int phone = 1228319567;
  final url = Uri.parse("https://wa.me/20$phone?text=$message");

  if (true) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
