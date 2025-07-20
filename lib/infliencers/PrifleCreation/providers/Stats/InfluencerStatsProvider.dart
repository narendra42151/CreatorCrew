import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfluencerStatsProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  Map<String, dynamic> _stats = {
    'totalEarnings': 0.0,
    'activeCampaigns': 0,
    'pendingSubmissions': 0,
    'todaysMeetings': 0,
  };

  bool get isLoading => _isLoading;
  Map<String, dynamic> get stats => _stats;

  Future<void> fetchAllStats(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch application stats
      final applicationStats = await _fetchApplicationStats(userId);

      // Fetch earnings
      final earnings = await _fetchEarnings(userId);

      // Fetch today's meetings
      final todaysMeetings = await _fetchTodaysMeetings(context, userId);

      _stats = {
        'totalEarnings': earnings,
        'activeCampaigns': applicationStats['activeCampaigns'],
        'pendingSubmissions': applicationStats['pendingSubmissions'],
        'todaysMeetings': todaysMeetings,
      };

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching stats: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, int>> _fetchApplicationStats(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('applications')
              .where('influencerId', isEqualTo: userId)
              .get();

      int activeCampaigns = 0;
      int pendingSubmissions = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? '';

        switch (status) {
          case 'accepted':
            activeCampaigns++;
            break;
          case 'submitted':
          case 'pending_review':
            pendingSubmissions++;
            break;
        }
      }

      return {
        'activeCampaigns': activeCampaigns,
        'pendingSubmissions': pendingSubmissions,
      };
    } catch (e) {
      print('Error fetching application stats: $e');
      return {'activeCampaigns': 0, 'pendingSubmissions': 0};
    }
  }

  Future<double> _fetchEarnings(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection('payments')
              .where('influencerId', isEqualTo: userId)
              .where('status', isEqualTo: 'completed')
              .get();

      double totalEarnings = 0.0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = data['influencerAmount'] ?? 0.0;
        totalEarnings += amount.toDouble();
      }

      return totalEarnings;
    } catch (e) {
      print('Error fetching earnings: $e');
      return 0.0;
    }
  }

  Future<int> _fetchTodaysMeetings(BuildContext context, String userId) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final todayEnd = todayStart.add(Duration(days: 1));

      final snapshot =
          await _firestore
              .collection('meetings')
              .where('influencerId', isEqualTo: userId)
              .get();

      int todaysMeetings = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final scheduledDateTime =
            (data['scheduledDateTime'] as Timestamp).toDate();

        if (scheduledDateTime.isAfter(todayStart) &&
            scheduledDateTime.isBefore(todayEnd) &&
            data['status'] == 'scheduled') {
          todaysMeetings++;
        }
      }

      return todaysMeetings;
    } catch (e) {
      print('Error fetching today\'s meetings: $e');
      return 0;
    }
  }
}
