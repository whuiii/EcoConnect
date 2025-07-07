import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Make sure you have this package

class AddressPlaceholder extends StatelessWidget {
  final String selectedCompany;

  const AddressPlaceholder({
    super.key,
    required this.selectedCompany,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: selectedCompany,
      enabled: false,
      maxLines: 3,
      style: TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Iconsax.location, color: Colors.black),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}
