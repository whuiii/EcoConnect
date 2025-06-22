import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registration function
  Future<String?> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String phone,
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match.";
    }

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Store extra data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'point': 0,
        'weight': 0,
        'frequency': 0,
      });

      return null; // null means success
    } catch (e) {
      print(e);
      return "Registration failed: ${e.toString()}";
    }
  }

  // Optional: Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting user profile: $e");
      return null;
    }
  }
}
