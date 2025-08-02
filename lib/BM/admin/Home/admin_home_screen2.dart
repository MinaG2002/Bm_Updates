import 'package:bmproject/BM/admin/Home/all_updates.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen2 extends StatefulWidget {
  const AdminHomeScreen2({super.key});

  @override
  State<AdminHomeScreen2> createState() => _AdminHomeScreen2State();
}

class _AdminHomeScreen2State extends State<AdminHomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllUpdates()),
                  );
                },
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1 - 100,
                  child: Center(
                    child: Text(
                      "Add updates",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
