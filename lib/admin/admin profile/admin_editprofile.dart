import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../../color.dart';
import '../../utilis.dart';

class AdminEditProfile extends StatefulWidget {
  @override
  State<AdminEditProfile> createState() => _AdminEditProfileState();
}

class _AdminEditProfileState extends State<AdminEditProfile> {
  Uint8List? _image;

  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _regNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loadCompanyData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance.collection('companies').doc(uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        _companyNameController.text = data['companyName'] ?? '';
        _regNumberController.text = data['registrationNumber'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phoneNumber'] ?? '';
        _addressController.text = data['address'] ?? '';
        _passwordController.text = "********";
      }
    } catch (e) {
      print("Error loading company data: $e");
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void _showChangePasswordDialog() {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final current = currentPassCtrl.text.trim();
              final newPass = newPassCtrl.text.trim();
              final confirm = confirmPassCtrl.text.trim();

              if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "All fields are required.",
                );
                return;
              }
              if (newPass != confirm) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "New passwords do not match.",
                );
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) throw Exception("No user signed in.");

                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: current,
                );

                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPass);

                Navigator.pop(context);
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.success,
                  text: "Password updated successfully!",
                );
              } catch (e) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "Failed: ${e.toString()}",
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _companyNameController.dispose();
    _regNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Company Profile"),
        ),
        body: FutureBuilder(
          future: loadCompanyData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 60,
                        backgroundImage: MemoryImage(_image!),
                      )
                          : const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/EcoConnect_Logo.png'),
                        backgroundColor: Colors.transparent,
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
                            icon: const Icon(Icons.add_a_photo, size: 18),
                            color: Colors.black,
                            onPressed: selectImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "EcoConnect",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),

                  _buildTextField(
                    controller: _companyNameController,
                    label: "Company Name",
                    hint: "Company name",
                    icon: Iconsax.building,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _regNumberController,
                    label: "Registration Number",
                    hint: "Registration number",
                    icon: Iconsax.document,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _emailController,
                    label: "Email",
                    hint: "company@email.com",
                    icon: Iconsax.sms,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _phoneController,
                    label: "Phone Number",
                    hint: "Company phone number",
                    icon: Iconsax.call,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    controller: _addressController,
                    label: "Company Address",
                    hint: "Full company address",
                    icon: Iconsax.location,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: _passwordController,
                    readOnly: true,
                    obscureText: true,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Change Password",
                      hintText: "********",
                      prefixIcon: const Icon(Iconsax.key, color: Colors.black, size: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black),
                        onPressed: _showChangePasswordDialog,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 18),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          title: "Save Changes",
                          text: "Do you want to save these changes?",
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                        );
                        // TODO: Save changes to Firestore here
                      },
                      color: button,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelStyle: const TextStyle(color: Colors.black, fontSize: 18),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
