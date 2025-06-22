import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In with Email & Password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Register with Email & Password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } catch (e) {
      print("Error registering: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}


