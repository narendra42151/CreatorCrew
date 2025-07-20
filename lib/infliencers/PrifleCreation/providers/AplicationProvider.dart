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
  // Future<List<ApplicationModel>> fetchMyApplications() async {
  //   setLoading(true);
  //   try {
  //     final userId = _auth.currentUser?.uid;
  //     if (userId == null) {
  //       setLoading(false);
  //       return [];
  //     }

  //     final snapshot =
  //         await _firestore
  //             .collection('applications')
  //             .where('influencerId', isEqualTo: userId)
  //             .orderBy('appliedAt', descending: true)
  //             .get();

  //     List<ApplicationModel> applications =
  //         snapshot.docs
  //             .map((doc) => ApplicationModel.fromJson(doc.data()))
  //             .toList();

  //     setLoading(false);
  //     return applications;
  //   } catch (e) {
  //     print('Error fetching applications: $e');
  //     setLoading(false);
  //     return [];
  //   }
  // }
  // Replace the existing fetchMyApplications method with this:
  Future<List<ApplicationModel>> fetchMyApplications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('Fetching applications for user: $userId'); // Debug log

      // Try without orderBy first to see if data exists
      final snapshot =
          await _firestore
              .collection('applications')
              .where('influencerId', isEqualTo: userId)
              .get();

      print('Found ${snapshot.docs.length} documents'); // Debug log

      if (snapshot.docs.isEmpty) {
        return [];
      }

      List<ApplicationModel> applications = [];

      for (var doc in snapshot.docs) {
        try {
          print('Processing document: ${doc.id}'); // Debug log
          print('Document data: ${doc.data()}'); // Debug log

          final data = doc.data();

          // Handle different timestamp formats
          if (data['appliedAt'] is Timestamp) {
            // If it's already a Timestamp, use it directly
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          } else if (data['appliedAt'] is String) {
            // If it's a string, try to parse it
            data['appliedAt'] = Timestamp.fromDate(
              DateTime.parse(data['appliedAt']),
            );
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          } else {
            // If appliedAt is missing or null, use current time
            data['appliedAt'] = Timestamp.now();
            final application = ApplicationModel.fromJson(data);
            applications.add(application);
          }
        } catch (e) {
          print('Error parsing application ${doc.id}: $e');
          // Continue with other documents
        }
      }

      // Sort in Dart instead of Firestore
      applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

      print(
        'Successfully parsed ${applications.length} applications',
      ); // Debug log
      return applications;
    } catch (e) {
      print('Error fetching applications: $e');
      throw e;
    }
  }
  // ...existing code...

  // ...existing code...

  // Add these new methods for stats
  Future<Map<String, int>> getInfluencerStats() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        return {
          'activeCampaigns': 0,
          'pendingSubmissions': 0,
          'completedCampaigns': 0,
        };
      }

      final snapshot =
          await _firestore
              .collection('applications')
              .where('influencerId', isEqualTo: userId)
              .get();

      int activeCampaigns = 0;
      int pendingSubmissions = 0;
      int completedCampaigns = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? '';

        switch (status) {
          case 'accepted':
            activeCampaigns++;
            break;
          case 'submitted':
            pendingSubmissions++;
            break;
          case 'completed':
            completedCampaigns++;
            break;
        }
      }

      return {
        'activeCampaigns': activeCampaigns,
        'pendingSubmissions': pendingSubmissions,
        'completedCampaigns': completedCampaigns,
      };
    } catch (e) {
      print('Error fetching influencer stats: $e');
      return {
        'activeCampaigns': 0,
        'pendingSubmissions': 0,
        'completedCampaigns': 0,
      };
    }
  }
}
