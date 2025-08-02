import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';

class Trubleshooting extends StatelessWidget {
  const Trubleshooting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.backgroundColor,
          child: Row(
            children: [
              SizedBox(width: 10),
              Text(
                "Trubleshooting",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        Container(height: 5, color: AppTheme.backgroundColor),

        Container(
          padding: EdgeInsets.only(left: 10),
          color: AppTheme.backgroundColor,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1 / 3,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      "wallet",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1 / 3,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      "Bm Online",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1 / 3,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      "insta Pay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 1 / 3,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(
                    child: Text(
                      "Appl Pay",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
