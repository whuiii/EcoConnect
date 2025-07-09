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
import '../../utilis.dart'; // your pickImage helper

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  String? existingImageUrl;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
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
        existingImageUrl = data['profileImage'];

        if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
          final networkImage = await networkImageToUint8List(existingImageUrl!);
          setState(() {
            _image = networkImage;
          });
        }
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
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
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      // Confirm with user before saving
      bool confirm = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Confirm Image"),
          content: const Text("Use this image for your profile?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text("Confirm")),
          ],
        ),
      );
      if (confirm == true) {
        setState(() {
          _image = img;
        });
      } else {
        print('❌ [DEBUG] User cancelled image selection.');
      }
    } else {
      print('❌ [DEBUG] No image picked.');
    }
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    try {
      print('🟢 [DEBUG] Starting image upload...');
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) throw Exception('User not signed in');
      if (image.isEmpty) throw Exception('Image data is empty');

      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profileImages')
          .child('$uid.jpg');

      print('🟢 [DEBUG] Uploading to path: ${ref.fullPath}');
      firebase_storage.UploadTask uploadTask = ref.putData(image);

      uploadTask.snapshotEvents.listen((snap) {
        print('📡 [DEBUG] State: ${snap.state}, ${snap.bytesTransferred}/${snap.totalBytes}');
      });

      firebase_storage.TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      print('✅ [DEBUG] Uploaded. URL: $downloadUrl');
      return downloadUrl;

    } catch (e) {
      print('❌ [DEBUG] Upload error: $e');
      throw Exception('Upload failed: $e');
    }
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
        'profileImage': imageUrl,
      };

      await FirebaseFirestore.instance.collection('users').doc(uid).update(updatedData);
      QuickAlert.show(context: context, type: QuickAlertType.success, text: "Profile updated!");
    } catch (e) {
      print('❌ [DEBUG] Error saving profile: $e');
      QuickAlert.show(context: context, type: QuickAlertType.error, text: "Error: ${e.toString()}");
    }
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
            TextField(controller: currentPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
            TextField(controller: newPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
            TextField(controller: confirmPassCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final current = currentPassCtrl.text.trim();
              final newPass = newPassCtrl.text.trim();
              final confirm = confirmPassCtrl.text.trim();

              if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                QuickAlert.show(context: context, type: QuickAlertType.error, text: "All fields required.");
                return;
              }
              if (newPass != confirm) {
                QuickAlert.show(context: context, type: QuickAlertType.error, text: "Passwords do not match.");
                return;
              }

              try {
                final user = FirebaseAuth.instance.currentUser;
                final cred = EmailAuthProvider.credential(email: user!.email!, password: current);
                await user.reauthenticateWithCredential(cred);
                await user.updatePassword(newPass);
                Navigator.pop(context);
                QuickAlert.show(context: context, type: QuickAlertType.success, text: "Password updated!");
              } catch (e) {
                QuickAlert.show(context: context, type: QuickAlertType.error, text: "Failed: ${e.toString()}");
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
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Edit Profile")),
        body: SingleChildScrollView(
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
                        : const AssetImage('assets/images/EcoConnect_Logo.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(Icons.add_a_photo, size: 18),
                        onPressed: selectImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("EcoConnect", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const Divider(height: 40),
              _buildTextField(_usernameController, "Username", "Username", Iconsax.user),
              const SizedBox(height: 15),
              _buildTextField(_emailController, "Email", "Email", Iconsax.sms),
              const SizedBox(height: 15),
              _buildTextField(_phoneController, "Phone Number", "Phone Number", Iconsax.call),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                readOnly: true,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Change Password",
                  prefixIcon: const Icon(Iconsax.key, size: 18),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showChangePasswordDialog,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: button),
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      title: "Confirm",
                      text: "Save profile changes?",
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      onConfirmBtnTap: () {
                        Navigator.pop(context);
                        saveProfileChanges();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18),
      ),
    );
  }
}
