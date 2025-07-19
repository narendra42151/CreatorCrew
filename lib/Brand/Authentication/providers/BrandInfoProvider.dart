// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/Influencers/Authentication/Models/BrandModel.dart';
// import 'package:creatorcrew/Influencers/Authentication/providers/CloudinaryProvider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BrandInfoProvider with ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final CloudinaryProvider _cloudinaryProvider = CloudinaryProvider();

//   BrandModel? _brandInfo;
//   bool _isLoading = false;

//   BrandModel? get brandInfo => _brandInfo;
//   bool get isLoading => _isLoading;

//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   Future<String?> uploadBrandLogo(File logoFile) async {
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) return null;

//       return await _cloudinaryProvider.uploadImage(
//         logoFile,
//         folder: 'creator_crew/brand_logos/$userId',
//       );
//     } catch (e) {
//       print('Error uploading brand logo: $e');
//       return null;
//     }
//   }

//   Future<bool> saveBrandInfo(BrandModel brandInfo, {File? logoFile}) async {
//     setLoading(true);
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) {
//         setLoading(false);
//         return false;
//       }

//       // Upload logo if provided
//       String? logoUrl;
//       if (logoFile != null) {
//         logoUrl = await uploadBrandLogo(logoFile);
//       }

//       // Create final brand info with logo URL and timestamps
//       final updatedBrandInfo = BrandModel(
//         id: userId,
//         brandName: brandInfo.brandName,
//         contactPerson: brandInfo.contactPerson,
//         contactNumber: brandInfo.contactNumber,
//         website: brandInfo.website,
//         email: brandInfo.email ?? _auth.currentUser!.email!,
//         logoUrl: logoUrl ?? brandInfo.logoUrl,
//         description: brandInfo.description,
//         industryType: brandInfo.industryType,
//         location: brandInfo.location,
//         companySize: brandInfo.companySize,
//         socialMedia: brandInfo.socialMedia,
//         marketingPreferences: brandInfo.marketingPreferences,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );

//       // Save to Firestore
//       await _firestore
//           .collection('brands')
//           .doc(userId)
//           .set(updatedBrandInfo.toJson());

//       _brandInfo = updatedBrandInfo;
//       setLoading(false);
//       return true;
//     } catch (e) {
//       print('Error saving brand info: $e');
//       setLoading(false);
//       return false;
//     }
//   }

//   Future<BrandModel?> fetchBrandInfo() async {
//     setLoading(true);
//     try {
//       final userId = _auth.currentUser?.uid;
//       if (userId == null) {
//         setLoading(false);
//         return null;
//       }

//       final doc = await _firestore.collection('brands').doc(userId).get();
//       if (!doc.exists) {
//         setLoading(false);
//         return null;
//       }

//       _brandInfo = BrandModel.fromJson(doc.data()!);
//       setLoading(false);
//       return _brandInfo;
//     } catch (e) {
//       print('Error fetching brand info: $e');
//       setLoading(false);
//       return null;
//     }
//   }
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Authentication/Models/BrandModel.dart';
import 'package:creatorcrew/Brand/Authentication/providers/CloudinaryProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandInfoProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryProvider _cloudinaryProvider = CloudinaryProvider();

  BrandModel? _brandInfo;
  bool _isLoading = false;

  BrandModel? get brandInfo => _brandInfo;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Method to save brand data to SharedPreferences
  Future<void> _saveBrandDataToPrefs(String brandName, String? logoUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brand_name', brandName);
    if (logoUrl != null) {
      await prefs.setString('brand_logo_url', logoUrl);
    }
  }

  Future<String?> uploadBrandLogo(File logoFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      return await _cloudinaryProvider.uploadImage(
        logoFile,
        folder: 'creator_crew/brand_logos/$userId',
      );
    } catch (e) {
      print('Error uploading brand logo: $e');
      return null;
    }
  }

  Future<bool> saveBrandInfo(BrandModel brandInfo, {File? logoFile}) async {
    setLoading(true);
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return false;
      }

      // Upload logo if provided
      String? logoUrl;
      if (logoFile != null) {
        logoUrl = await uploadBrandLogo(logoFile);
      }

      // Create final brand info with logo URL and timestamps
      final updatedBrandInfo = BrandModel(
        id: userId,
        brandName: brandInfo.brandName,
        contactPerson: brandInfo.contactPerson,
        contactNumber: brandInfo.contactNumber,
        website: brandInfo.website,
        email: brandInfo.email ?? _auth.currentUser!.email!,
        logoUrl: logoUrl ?? brandInfo.logoUrl,
        description: brandInfo.description,
        industryType: brandInfo.industryType,
        location: brandInfo.location,
        companySize: brandInfo.companySize,
        socialMedia: brandInfo.socialMedia,
        marketingPreferences: brandInfo.marketingPreferences,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestore
          .collection('brands')
          .doc(userId)
          .set(updatedBrandInfo.toJson());

      _brandInfo = updatedBrandInfo;

      // Save to SharedPreferences
      await _saveBrandDataToPrefs(
        updatedBrandInfo.brandName,
        updatedBrandInfo.logoUrl,
      );

      setLoading(false);
      return true;
    } catch (e) {
      print('Error saving brand info: $e');
      setLoading(false);
      return false;
    }
  }

  Future<BrandModel?> fetchBrandInfo() async {
    setLoading(true);
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return null;
      }

      final doc = await _firestore.collection('brands').doc(userId).get();
      if (!doc.exists) {
        setLoading(false);
        return null;
      }

      _brandInfo = BrandModel.fromJson(doc.data()!);

      // Save to SharedPreferences when fetching
      if (_brandInfo != null) {
        await _saveBrandDataToPrefs(_brandInfo!.brandName, _brandInfo!.logoUrl);
      }

      setLoading(false);
      return _brandInfo;
    } catch (e) {
      print('Error fetching brand info: $e');
      setLoading(false);
      return null;
    }
  }
}
