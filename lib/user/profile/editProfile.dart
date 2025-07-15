// Add at the top:
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

      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        _usernameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        existingImageUrl = data['profileImage'];

        // ✅ No need to pre-download the image
        if (mounted) {
          setState(() {});
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
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (_) {
      debugPrint("Image pick canceled");
    }
  }

  Future<String> uploadImageToStorage(Uint8List image) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('User not signed in');
    if (image.isEmpty) throw Exception('Image data is empty');

    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImages/users')
        .child('$uid.jpg');

    firebase_storage.UploadTask uploadTask = ref.putData(image);
    firebase_storage.TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  Future<void> uploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) return; // User cancelled the picker

    final Uint8List imageData = await imageFile.readAsBytes();

    try {
      // Upload to Firebase Storage
      final imageUrl = await uploadImageToStorage(imageData);

      // Show success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded! URL: $imageUrl')),
      );
    } catch (e) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
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
        //'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'profileImage': imageUrl,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updatedData);

      if (!mounted) return;
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Profile updated!",
        onConfirmBtnTap: () {
          Navigator.pop(context); // Dismiss alert
          Navigator.pop(context, true); // Go back to previous screen
        },
      );
    } catch (e) {
      print('❌ [DEBUG] Error saving profile: $e');
      if (!mounted) return;
      QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: "Error: ${e.toString()}");
    }
  }

  void _showChangePasswordDialog() {
    final currentPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        bool _currentObscure = true;
        bool _newObscure = true;
        bool _confirmObscure = true;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Change Password'),
            content: SizedBox(
              width: 400, // ✅ makes the dialog wider!
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentPassCtrl,
                      obscureText: _currentObscure,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _currentObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentObscure = !_currentObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPassCtrl,
                      obscureText: _newObscure,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _newObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _newObscure = !_newObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPassCtrl,
                      obscureText: _confirmObscure,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _confirmObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _confirmObscure = !_confirmObscure;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () async {
                  final current = currentPassCtrl.text.trim();
                  final newPass = newPassCtrl.text.trim();
                  final confirm = confirmPassCtrl.text.trim();

                  if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "All fields required.");
                    return;
                  }
                  if (newPass != confirm) {
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "Passwords do not match.");
                    return;
                  }

                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    final cred = EmailAuthProvider.credential(
                        email: user!.email!, password: current);
                    await user.reauthenticateWithCredential(cred);
                    await user.updatePassword(newPass);
                    if (mounted) {
                      Navigator.pop(context);
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: "Password updated!");
                    }
                  } catch (e) {
                    if (!mounted) return;
                    QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: "Failed: ${e.toString()}");
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
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

  ImageProvider getProfileImage() {
    if (_image != null) return MemoryImage(_image!);
    if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return NetworkImage(existingImageUrl!); // Load directly
    }
    return const AssetImage('assets/images/EcoConnect_Logo.png');
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
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipOval(
                      child: _image != null
                          ? Image.memory(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : (existingImageUrl != null &&
                                  existingImageUrl!.isNotEmpty
                              ? Image.network(
                                  existingImageUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/images/EcoConnect_Logo.png');
                                  },
                                )
                              : Image.asset(
                                  'assets/images/EcoConnect_Logo.png')),
                    ),
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
              const Text("EcoConnect",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
              const Divider(height: 40),
              _buildTextField(
                  _usernameController, "Username", "Username", Iconsax.user),
              //const SizedBox(height: 15),
              //_buildTextField(_emailController, "Email", "Email", Iconsax.sms),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         "Email",
              //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //       ),
              //       const SizedBox(height: 4),
              //       Text(
              //         _emailController.text,
              //         style: const TextStyle(fontSize: 14, color: Colors.black87),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 15),
              _buildTextField(_phoneController, "Phone Number", "Phone Number",
                  Iconsax.call),
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
                  child: const Text("Save Changes",
                      style: TextStyle(color: Colors.white)),
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

  Widget _buildTextField(TextEditingController controller, String label,
      String hint, IconData icon) {
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
