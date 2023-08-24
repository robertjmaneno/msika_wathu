import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class AuthController {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String> uploadProfileImageToStorage(XFile? globalImage) async {
    try {
      if (globalImage == null) {
        throw Exception('Image is null');
      }

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in');
      }

      Reference ref = _storage.ref().child('profile').child(user.uid);

      // Read the image file and convert it to bytes
      Uint8List imageBytes = await globalImage.readAsBytes();

      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<XFile?> imagePicker(BuildContext context, ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);

      if (pickedImage != null) {
        return pickedImage;
      } else {
        return null;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while picking an image: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return null;
    }
  }

  Future<String> signUpUsers(String email, String fullName, String phoneNumber,
      String password, XFile? globalImage) async {
    try {
      if (email.isEmpty &&
          fullName.isEmpty &&
          phoneNumber.isEmpty &&
          password.isEmpty ||
          globalImage != null) {
        return 'Please fill in all the fields.';
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String profileImageUrl = await uploadProfileImageToStorage(globalImage);
      User? user = userCredential.user;
      if (user != null) {
        // Store additional user information in Firestore
        await _firestore.collection('buyers').doc(user.uid).set({
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'email': email,
          'userId': userCredential.user!.uid,
          'address': '',
          'profileImage': profileImageUrl,
          // Add more user data fields as needed
        });

        return 'Success';
      } else {
        return 'Registration failed. Please try again later.';
      }
    } catch (e) {
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

      return 'An error occurred during registration.';
    }
  }
}
