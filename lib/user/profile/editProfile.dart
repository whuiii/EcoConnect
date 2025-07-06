import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../color.dart';
import '../../utilis.dart'; // Make sure pickImage() is defined here

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  String? existingImageUrl;

  // Controllers for fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('No user signed in.');

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        _usernameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _bioController.text = data['bio'] ?? '';
        existingImageUrl = data['profileImage'];

        if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
          final networkImage = await networkImageToUint8List(existingImageUrl!);
          setState(() {
            _image = networkImage;
          });
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<Uint8List> networkImageToUint8List(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load network image');
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImages')
        .child('$uid.jpg');

    firebase_storage.UploadTask uploadTask = ref.putData(image);
    firebase_storage.TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveProfileChanges() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('No user signed in.');

      String imageUrl = existingImageUrl ?? '';

      if (_image != null) {
        imageUrl = await uploadImageToStorage(_image!);
      }

      final updatedData = {
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'profileImage': imageUrl,
      };

      await FirebaseFirestore.instance.collection('users').doc(uid).update(updatedData);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Profile updated successfully!",
      );
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: "Error: ${e.toString()}",
      );
    }
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
                decoration: const InputDecoration(labelText: 'Current Password'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
              setState(() {
                _passwordController.text = newPass;
              });
              Navigator.of(context).pop();
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: "Password updated locally! (Hook up your backend)",
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(radius: 60, backgroundImage: MemoryImage(_image!))
                        : CircleAvatar(
                      radius: 60,
                      backgroundImage: existingImageUrl != null
                          ? NetworkImage(existingImageUrl!)
                          : AssetImage('assets/images/EcoConnect_Logo.png')
                      as ImageProvider,
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
                const Text("EcoConnect", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                _buildTextField(controller: _usernameController, label: "Username", hint: "Username", icon: Iconsax.user),
                const SizedBox(height: 20),
                _buildTextField(controller: _emailController, label: "Email", hint: "Email", icon: Iconsax.sms),
                const SizedBox(height: 20),
                _buildTextField(controller: _phoneController, label: "Phone Number", hint: "Phone Number", icon: Iconsax.call),
                const SizedBox(height: 20),
                _buildTextField(controller: _bioController, label: "Bio", hint: "Write something about yourself", icon: Iconsax.note_text, maxLines: 3),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  readOnly: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Change Password",
                    hintText: "********",
                    prefixIcon: const Icon(Iconsax.key, size: 18),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.black),
                      onPressed: _showChangePasswordDialog,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10),
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
                        title: "Save Changes",
                        text: "Do you want to save these changes?",
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () {
                          Navigator.of(context).pop();
                          saveProfileChanges();
                        },
                      );
                    },
                    color: button,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: const Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
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
        prefixIcon: Icon(icon, size: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
