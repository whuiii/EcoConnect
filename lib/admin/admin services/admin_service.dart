import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Admin Registration function
  Future<String?> registerAdminCompany({
    required String companyLogo,
    required String companyName,
    required String registrationNumber,
    required String address,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    try {
      // Create admin in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Store extra data in Firestore
      await _firestore.collection('admins').doc(uid).set({
        'companyName': companyName,
        'companyLogo': companyLogo,
        'registrationNumber': registrationNumber,
        'address': address,
        'email': email,
        'phone': phone,
        'uid': uid,
        // You can upload the companyLogo to Firebase Storage
        // and store the download URL instead of the raw bytes.
        // For now, we’ll skip that step in this example.
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null; // success
    } catch (e) {
      print(e);
      return "Admin registration failed: ${e.toString()}";
    }
  }

  // Get admin company profile
  Future<Map<String, dynamic>?> getAdminProfile(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('admins').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting admin profile: $e");
      return null;
    }
  }

  // Get all admin companies
  Future<List<Map<String, dynamic>>> getAllAdmins() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('admins').get();
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print("Error fetching admins: $e");
      return [];
    }
  }
}
