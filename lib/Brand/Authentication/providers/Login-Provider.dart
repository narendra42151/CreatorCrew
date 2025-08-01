import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserRole { brand, influencer }

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get user => _user;

  Future<void> _saveUserSession(
    String email,
    String role,
    String? displayName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);
    await prefs.setString('userRole', role);
    if (displayName != null) {
      await prefs.setString('displayName', displayName);
    }
  }

  // Clear user session data on logout
  Future<void> _clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Get current user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  Future<String?> signInWithGoogle(UserRole role) async {
    try {
      // Begin Google sign in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return 'Google sign-in aborted';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credential
      UserCredential cred = await _auth.signInWithCredential(credential);
      _user = cred.user;

      if (_user != null) {
        await _saveUserSession(_user!.email!, role.name, _user!.displayName);
      }

      // Check if user exists in Firestore
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_user!.email).get();

      // If this is a new user (first time using Google sign-in)
      if (!doc.exists) {
        // Create a new user entry with the selected role
        await _firestore.collection('users').doc(_user!.email).set({
          'email': _user!.email,
          'role': role.name,
          'name': _user!.displayName ?? 'User',
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': _user!.photoURL,
          'authProvider': 'google',
        });
      }
      // If user exists but with wrong role
      else if (doc['role'] != role.name) {
        await _auth.signOut();
        return 'You\'re registered with a different role. Please use the correct tab.';
      }
      if (_user != null) {
        await _saveUserSession(_user!.email!, role.name, _user!.displayName);

        // If it's a brand user, fetch and save brand info to SharedPreferences
        if (role == UserRole.brand) {
          await _fetchAndSaveBrandInfo();
        }
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      await _googleSignIn.signOut();
      return e.message;
    } catch (e) {
      await _googleSignIn.signOut();
      return 'An error occurred: ${e.toString()}';
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required UserRole role,
    required String name,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = cred.user;
      await _saveUserSession(email, role.name, name);
      // Save user role and extra info in Firestore
      await _firestore.collection('users').doc(_user!.email).set({
        'email': email,
        'role': role.name,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = cred.user;

      // Check role in Firestore
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_user!.email).get();
      String? name = doc['name'];
      await _saveUserSession(email, role.name, name);
      if (!doc.exists || doc['role'] != role.name) {
        await _auth.signOut();
        return 'Role mismatch or user not found';
      }
      if (role == UserRole.brand) {
        await _fetchAndSaveBrandInfo();
      } else if (role == UserRole.influencer) {
        await _fetchAndSaveInfluencerInfo();
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> _fetchAndSaveInfluencerInfo() async {
    try {
      final userId = _user?.uid;
      if (userId == null) return;

      final doc = await _firestore.collection('influencers').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();

        // Save influencer name, username and profile URL to SharedPreferences
        if (data['fullName'] != null) {
          await prefs.setString('influencer_name', data['fullName']);
        }
        if (data['username'] != null) {
          await prefs.setString('influencer_username', data['username']);
        }
        if (data['profilePictureUrl'] != null) {
          await prefs.setString(
            'influencer_profile_url',
            data['profilePictureUrl'],
          );
        }
        await prefs.setBool('is_influencer_onboarded', true);
      }
    } catch (e) {
      print('Error fetching influencer info during sign-in: $e');
    }
  }

  Future<void> _fetchAndSaveBrandInfo() async {
    try {
      final userId = _user?.uid;
      if (userId == null) return;

      final doc = await _firestore.collection('brands').doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final prefs = await SharedPreferences.getInstance();

        // Save brand name and logo URL to SharedPreferences
        if (data['brandName'] != null) {
          await prefs.setString('brand_name', data['brandName']);
        }
        if (data['logoUrl'] != null) {
          await prefs.setString('brand_logo_url', data['logoUrl']);
        }
      }
    } catch (e) {
      print('Error fetching brand info during sign-in: $e');
    }
  }

  Future<String?> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _clearUserSession();
    _user = null;
    notifyListeners();
  }
}
