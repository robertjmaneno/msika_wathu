import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUsers(
    String email,
    String fullName,
    String phoneNumber,
    String password,
  ) async {
    try {
      // Check if any of the fields are empty
      if (email.isEmpty ||
          fullName.isEmpty ||
          phoneNumber.isEmpty ||
          password.isEmpty) {
        return 'Please fill in all the fields.';
      }

      // Create the user with email and password
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('buyers').doc(cred.user!.uid).set(
          {'email': email, 'fullName': fullName, 'phoneNumber': phoneNumber});

      // Registration successful
      return 'Success';
    } catch (e) {
      // Handle specific registration errors here
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            return 'The password provided is too weak.';
          case 'email-already-in-use':
            return 'The account already exists for that email.';
          case 'invalid-email':
            return 'The email address is not valid.';
          default:
            return 'Registration failed. Please try again later.';
        }
      }

      // Handle other unexpected errors
      return 'An error occurred during registration.';
    }
  }
}
