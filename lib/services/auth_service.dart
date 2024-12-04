import 'dart:async';

import 'package:drivers_management_app/screens/dashboard/kpis_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  driver,
  manager,
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
    String? phoneNumber,
    UserRole? role,
  }) async {
    try {
      print("Starting Firebase Auth signup...");

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Only attempt Firestore operations if additional info is provided
      if (fullName != null || phoneNumber != null || role != null) {
        print("Attempting to create Firestore profile...");

        try {
          final Map<String, dynamic> userData = {
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          };

          if (fullName != null) userData['fullName'] = fullName;
          if (phoneNumber != null) userData['phoneNumber'] = phoneNumber;
          if (role != null) userData['role'] = role.toString();

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userData)
              .timeout(const Duration(seconds: 5)); // Add timeout

          print("Firestore profile created successfully");
        } catch (firestoreError) {
          // Log but don't rethrow Firestore errors
          print("Firestore error (non-fatal): $firestoreError");
        }
      }

      // Return the userCredential regardless of Firestore success
      return userCredential;
    } catch (e) {
      print("Fatal error in signUpWithEmail: $e");
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print("Starting login process...");
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Login successful");
      return userCredential;
    } catch (e) {
      print("Error in signInWithEmail: $e");
      rethrow;
    }
  }
}
