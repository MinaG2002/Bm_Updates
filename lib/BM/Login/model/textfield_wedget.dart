// ignore_for_file: non_constant_identifier_names

import 'package:bmproject/generated/l10n.dart';
import 'package:bmproject/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String lapel;
  final TextInputType TextInputTypeee;

  final bool Trueee;
  final String Hinttexttt;
  final TextEditingController controlll;

  const CustomTextField({
    super.key,
    required this.lapel,
    required this.TextInputTypeee,
    required this.Trueee,
    required this.Hinttexttt,
    required this.controlll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(children: [Text(lapel)]),
          const SizedBox(height: 5),
          TextFormField(
            validator: (value) => value!.isEmpty ? S.of(context).Please : null,
            textInputAction: TextInputAction.next,
            controller: controlll,
            keyboardType: TextInputTypeee,
            obscureText: Trueee,
            decoration: InputDecoration(
              hintText: Hinttexttt,
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
        ],
      ),
    );
  }
}
