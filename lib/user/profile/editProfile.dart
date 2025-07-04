import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../../color.dart';
import '../../utilis.dart'; // Make sure this has your pickImage() helper

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;

  // Controllers for fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final current = currentPasswordController.text.trim();
              final newPass = newPasswordController.text.trim();
              final confirm = confirmPasswordController.text.trim();

              if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "All fields are required!",
                );
                return;
              }

              if (newPass != confirm) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: "New passwords do not match!",
                );
                return;
              }

              // You can add your current password validation here.
              // Example: if (current != storedPassword) { ... }

              setState(() {
                _passwordController.text = newPass;
              });

              Navigator.of(context).pop();

              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Password updated successfully!",
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                      backgroundImage:
                      AssetImage('assets/images/EcoConnect_Logo.png'),
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

                // Username
                _buildTextField(
                  controller: _usernameController,
                  label: "Username",
                  hint: "Username",
                  icon: Iconsax.user,
                ),
                const SizedBox(height: 20),

                // Email
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Email",
                  icon: Iconsax.sms,
                ),
                const SizedBox(height: 20),

                // Phone Number
                _buildTextField(
                  controller: _phoneController,
                  label: "Phone Number",
                  hint: "Phone Number without -",
                  icon: Iconsax.call,
                ),
                const SizedBox(height: 20),

                // Bio Data
                _buildTextField(
                  controller: _bioController,
                  label: "Bio Data",
                  hint: "Write something about yourself",
                  icon: Iconsax.note_text,
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                // Change Password
                TextField(
                  controller: _passwordController,
                  readOnly: true, // prevent editing directly
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    labelText: "Change Password",
                    hintText: "********",
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: const Icon(
                      Iconsax.key,
                      color: Colors.black,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: _showChangePasswordDialog,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
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
                        text: "Do you want to save these changes?",
                        title: "Save Changes",
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                      );
                    },
                    color: button,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 50),
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
          ),
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
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        labelStyle: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        floatingLabelStyle:
        const TextStyle(color: Colors.black, fontSize: 18),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
