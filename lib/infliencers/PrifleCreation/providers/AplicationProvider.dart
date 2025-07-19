import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/influencerSeasionManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ApplicationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Submit application for a campaign
  Future<String?> submitApplication({
    required String campaignId,
    required String brandId,
    required String campaignTitle,
    String? message,
  }) async {
    setLoading(true);
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return 'User not authenticated';
      }

      // Get influencer data
      final influencerData = await InfluencerSessionManager.getInfluencerData();
      final influencerName = influencerData['name'] ?? 'Unknown';
      final influencerEmail =
          influencerData['email'] ?? _auth.currentUser!.email!;

      // Check if already applied
      final existingApplication =
          await _firestore
              .collection('applications')
              .where('campaignId', isEqualTo: campaignId)
              .where('influencerId', isEqualTo: userId)
              .get();

      if (existingApplication.docs.isNotEmpty) {
        setLoading(false);
        return 'You have already applied for this campaign';
      }

      // Create application
      final application = ApplicationModel(
        campaignId: campaignId,
        influencerId: userId,
        brandId: brandId,
        campaignTitle: campaignTitle,
        influencerName: influencerName,
        influencerEmail: influencerEmail,
        status: 'pending',
        message: message,
        appliedAt: DateTime.now(),
      );

      // Save to Firestore
      DocumentReference docRef = await _firestore
          .collection('applications')
          .add(application.toJson());

      // Update with document ID
      await docRef.update({'id': docRef.id});

      setLoading(false);
      return null; // Success
    } catch (e) {
      print('Error submitting application: $e');
      setLoading(false);
      return 'Error submitting application: $e';
    }
  }

  // Fetch applications for current influencer
  Future<List<ApplicationModel>> fetchMyApplications() async {
    setLoading(true);
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return [];
      }

      final snapshot =
          await _firestore
              .collection('applications')
              .where('influencerId', isEqualTo: userId)
              .orderBy('appliedAt', descending: true)
              .get();

      List<ApplicationModel> applications =
          snapshot.docs
              .map((doc) => ApplicationModel.fromJson(doc.data()))
              .toList();

      setLoading(false);
      return applications;
    } catch (e) {
      print('Error fetching applications: $e');
      setLoading(false);
      return [];
    }
  }
}
