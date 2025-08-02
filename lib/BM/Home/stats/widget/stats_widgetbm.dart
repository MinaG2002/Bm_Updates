// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class StatesWidgetBm extends StatelessWidget {
  final String imgeurl;
  final String titel;

  const StatesWidgetBm({super.key, required this.imgeurl, required this.titel});

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 0, left: 10),
          child: Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.orange, width: 3),
            ),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 3),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(imgeurl),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "    ${(titel)}",
          // "internet",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
