import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BrandApplicationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fetch all applications for brand's campaigns
  Future<List<ApplicationModel>> fetchBrandApplications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('Fetching applications for brand: $userId');

      // Get all applications for this brand
      final snapshot =
          await _firestore
              .collection('applications')
              .where('brandId', isEqualTo: userId)
              .get();

      print('Found ${snapshot.docs.length} applications for brand');

      List<ApplicationModel> applications = [];

      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();

          // Handle timestamp formats
          if (data['appliedAt'] is Timestamp) {
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          } else if (data['appliedAt'] is String) {
            data['appliedAt'] = Timestamp.fromDate(
              DateTime.parse(data['appliedAt']),
            );
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          } else {
            data['appliedAt'] = Timestamp.now();
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          }
        } catch (e) {
          print('Error parsing application ${doc.id}: $e');
        }
      }

      // Sort by most recent first
      applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

      print('Successfully parsed ${applications.length} applications');
      return applications;
    } catch (e) {
      print('Error fetching brand applications: $e');
      throw e;
    }
  }

  // Update application status
  Future<String?> updateApplicationStatus({
    required String applicationId,
    required String status, // 'accepted' or 'rejected'
  }) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': status,
        'respondedAt': DateTime.now(),
      });

      notifyListeners();
      return null; // Success
    } catch (e) {
      print('Error updating application status: $e');
      return 'Error updating application: $e';
    }
  }
}
