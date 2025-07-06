import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navigate/admin/admin%20services/admin_service.dart';
import 'package:navigate/admin/admin_login.dart';
import 'package:navigate/utilis.dart';

import '../color.dart';


class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    // Create a reference to Firebase Storage
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('companyLogos')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file
    firebase_storage.UploadTask uploadTask = ref.putData(image);

    // Wait for upload to finish
    firebase_storage.TaskSnapshot snap = await uploadTask;

    // Get download URL
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  bool securePassword = true;
  bool? isChecked = false;

  // Text controllers
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController registrationNumberController = TextEditingController();
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    setState(() {
      _isPasswordEightCharacters = password.length >= 8;
      _hasPasswordOneNumber = numericRegex.hasMatch(password);
    });
  }

  final companyService = AdminService();
  void handleAdminRegister() async {
    try {
      String logoUrl = '';

      if (_image != null) {
        logoUrl = await uploadImageToStorage(_image!);
      }
      String? result = await companyService.registerAdminCompany(
      companyLogo: logoUrl,
      companyName: companyNameController.text.trim(),
      registrationNumber: registrationNumberController.text.trim(),
      address: addressController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
    );
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful!"))
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result))
      );
    }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}"))
      );
    }

  }

    // TODO: Add Firebase/Backend logic here.
  //   print("Company Name: ${companyNameController.text}");
  //   print("Reg No: ${registrationNumberController.text}");
  //   print("Service Type: ${serviceTypeController.text}");
  //   print("Address: ${addressController.text}");
  //   print("Username: ${usernameController.text}");
  //   print("Email: ${emailController.text}");
  //   print("Phone: ${phoneController.text}");
  //   print("Password: ${passwordController.text}");
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Admin company registered successfully!")),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
      Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              FadeInUp(
                child: Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                        radius: 60, backgroundImage: MemoryImage(_image!))
                        : CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/EcoConnect_Logo.png'),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey.shade300,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.add_a_photo, size: 18),
                          color: Colors.black,
                          onPressed: selectImage,
                          iconSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              FadeInUp(
                child: Text("Welcome Waste Company",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              ),
              SizedBox(height: 5),
              FadeInUp(
                child: Text("Register to EcoConnect",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ),
              SizedBox(height: 30),

              // Admin-specific fields
              FadeInUp(
                child: TextField(
                  controller: companyNameController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Company Name", Iconsax.building),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: TextField(
                  controller: registrationNumberController,
                  cursorColor: Colors.black,

                  decoration: inputDecoration("Business Reg. No.in SSM",
                      Iconsax.document),
                ),
              ),
              // SizedBox(height: 20),
              // FadeInUp(
              //   child: TextField(
              //     controller: serviceTypeController,
              //     cursorColor: Colors.black,
              //     decoration: inputDecoration("Waste Service Type", Iconsax.trash),
              //   ),
              // ),
              SizedBox(height: 20),
              FadeInUp(
                child: TextField(
                  controller: addressController,
                  cursorColor: Colors.black,
                  maxLines: 2,
                  decoration: inputDecoration("Company Address", Iconsax.location),
                ),
              ),
              // SizedBox(height: 20),
              //
              // // Reuse user fields
              // FadeInUp(
              //   child: TextField(
              //     controller: usernameController,
              //     cursorColor: Colors.black,
              //     decoration: inputDecoration("Username", Iconsax.user),
              //   ),
              // ),
              SizedBox(height: 20),
              FadeInUp(
                child: TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Company Email", Iconsax.sms),
                ),
              ),
              SizedBox(height: 20),
              FadeInUp(
                child: TextField(
                  controller: phoneController,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Company Phone", Iconsax.call),
                ),
              ),
              SizedBox(height: 20),

              FadeInUp(
                child: TextField(
                  controller: passwordController,
                  onChanged: onPasswordChanged,
                  obscureText: securePassword,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Password", Iconsax.key).copyWith(
                    suffixIcon: togglePassword(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                child: Row(
                  children: [
                    passwordRequirementCheck(_isPasswordEightCharacters, "At least 8 characters"),
                  ],
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                child: Row(
                  children: [
                    passwordRequirementCheck(_hasPasswordOneNumber, "At least 1 number"),
                  ],
                ),
              ),
              SizedBox(height: 20),

              FadeInUp(
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: securePassword,
                  cursorColor: Colors.black,
                  decoration: inputDecoration("Confirm Password", Iconsax.lock).copyWith(
                    suffixIcon: togglePassword(),
                  ),
                ),
              ),
              SizedBox(height: 20),

              FadeInUp(
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (val) => setState(() => isChecked = val),
                    ),
                    Text("I agree to the Terms & Privacy Policy")
                  ],
                ),
              ),
              FadeInUp(
                child: MaterialButton(
                  onPressed: handleAdminRegister,
                  height: 45,
                  minWidth: double.infinity,
                  color: button,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Text("SIGN UP",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Get.to(AdminLoginPage());
                      },
                      child: Text("Login", style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      hintText: label,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon, color: Colors.black, size: 18),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      floatingLabelStyle: TextStyle(color: Colors.black, fontSize: 18),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget passwordRequirementCheck(bool condition, String text) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: condition ? Colors.green : Colors.transparent,
            border: Border.all(color: condition ? Colors.transparent : Colors.grey.shade400),
            borderRadius: BorderRadius.circular(50),
          ),
          child: condition ? Icon(Icons.check, color: Colors.white, size: 15) : SizedBox(),
        ),
        SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () => setState(() => securePassword = !securePassword),
      icon: Icon(securePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
    );
  }
}
