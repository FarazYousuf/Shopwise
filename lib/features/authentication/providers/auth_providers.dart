import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _user = user;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Error signing in with email and password: $e');
      rethrow;
    }
  }

  // Sign Up with Email and Password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the user's profile
      await userCredential.user
          ?.updateProfile(displayName: '$firstName $lastName');
      await userCredential.user?.reload();
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      print('Error signing up with email and password: $e');
      rethrow;
    }
  }

  // Future<void> signUpWithEmailAndPassword(String email, String password, String firstName, String lastName) async {
  //   UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

  //   // Update the user's profile
  //   await userCredential.user?.updateDisplayName('$firstName $lastName');

  // }

  // Future<void> signUpWithEmailAndPassword({
  //   required String email,
  //   required String password,
  //   required String firstName,
  //   required String lastName,
  //   required String username,
  //   required String phoneNumber,
  // }) async {
  //   try {
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Update the user's profile
  //     await userCredential.user
  //         ?.updateProfile(displayName: '$firstName $lastName');

  //     // Save additional user details to Firestore
  //     await _firestore.collection('users').doc(userCredential.user?.uid).set({
  //       'firstName': firstName,
  //       'lastName': lastName,
  //       'username': username,
  //       'phoneNumber': phoneNumber,
  //       'email': email,
  //       'uid': userCredential.user?.uid,
  //     });
  //   } catch (e) {
  //     print('Error signing up with email and password: $e');
  //     rethrow;
  //   }
  // }

  // // Method for sending password reset email
  // Future<void> sendPasswordResetEmail(String email) async {
  //   await _auth.sendPasswordResetEmail(email: email);
  // }

  // Send Password Reset Email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
      );
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Apple: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
