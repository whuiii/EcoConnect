import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FillInBlank extends StatelessWidget {
  final String text;
  final String hint;
  final IconData icon;
  final bool isEnabled;
  const FillInBlank(
      {super.key,
      required this.text,
      required this.icon,
      required this.hint,
      required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: isEnabled,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: text,
        hintText: hint,
        filled: true, // Enable background fill
        fillColor: isEnabled ? Colors.white : Colors.grey[100],
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          // 👈 Match enabled border
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
