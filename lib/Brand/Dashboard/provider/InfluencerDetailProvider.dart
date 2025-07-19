// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:flutter/material.dart';

// class InfluencerDetailProvider extends ChangeNotifier {
//   Map<String, dynamic>? _influencerData;
//   bool _isLoading = true;
//   bool _isUpdating = false;
//   String? _error;

//   Map<String, dynamic>? get influencerData => _influencerData;
//   bool get isLoading => _isLoading;
//   bool get isUpdating => _isUpdating;
//   String? get error => _error;

//   Future<void> loadInfluencerDetails(ApplicationModel application) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       print('Loading influencer details for ID: ${application.influencerId}');

//       // First, try to get from 'influencers' collection
//       DocumentSnapshot doc =
//           await FirebaseFirestore.instance
//               .collection('influencers')
//               .doc(application.influencerId)
//               .get();

//       if (doc.exists) {
//         print('Found in influencers collection: ${doc.data()}');
//         final rawData = doc.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );
//         _influencerData = transformedData;
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       // If not found, try 'users' collection
//       doc =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(application.influencerId)
//               .get();

//       if (doc.exists) {
//         print('Found in users collection: ${doc.data()}');
//         final rawData = doc.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );
//         _influencerData = transformedData;
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       // Try querying by email in influencers collection
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance
//               .collection('influencers')
//               .where('email', isEqualTo: application.influencerEmail)
//               .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         print('Found by email query: ${querySnapshot.docs.first.data()}');
//         final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );
//         _influencerData = transformedData;
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       // Try users collection by email
//       querySnapshot =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .where('email', isEqualTo: application.influencerEmail)
//               .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         print('Found in users by email: ${querySnapshot.docs.first.data()}');
//         final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );
//         _influencerData = transformedData;
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       print('No influencer data found in any collection');
//       _influencerData = null;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print('Error loading influencer details: $e');
//       _error = 'Failed to load influencer details';
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   Future<bool> updateApplicationStatus(
//     String applicationId,
//     String status,
//   ) async {
//     _isUpdating = true;
//     notifyListeners();

//     try {
//       await FirebaseFirestore.instance
//           .collection('applications')
//           .doc(applicationId)
//           .update({'status': status, 'respondedAt': DateTime.now()});

//       _isUpdating = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       print('Error updating application status: $e');
//       _error = 'Failed to update application status';
//       _isUpdating = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Transform the nested InfluencerProfile data to flat structure
//   Map<String, dynamic> _transformInfluencerData(Map<String, dynamic> rawData) {
//     Map<String, dynamic> transformed = Map.from(rawData);

//     // Extract social media data and calculate totals
//     if (rawData['socialMediaAccounts'] != null) {
//       List<dynamic> socialAccounts = rawData['socialMediaAccounts'];
//       int totalFollowers = 0;
//       double totalEngagement = 0.0;
//       int accountsWithEngagement = 0;

//       for (var account in socialAccounts) {
//         String platform = account['platform']?.toLowerCase() ?? '';

//         // Add follower counts
//         if (account['followerCount'] != null) {
//           totalFollowers += (account['followerCount'] as int);
//         }

//         // Add engagement rates
//         if (account['engagementRate'] != null) {
//           totalEngagement += (account['engagementRate'] as double);
//           accountsWithEngagement++;
//         }

//         // Extract platform-specific data
//         switch (platform) {
//           case 'instagram':
//             transformed['instagram'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['instagramFollowers'] = account['followerCount'];
//             transformed['instagramEngagement'] = account['engagementRate'];
//             break;
//           case 'youtube':
//             transformed['youtube'] =
//                 account['username'] ?? account['channelLink'];
//             transformed['youtubeFollowers'] = account['followerCount'];
//             transformed['youtubeViews'] = account['avgViews'];
//             break;
//           case 'tiktok':
//             transformed['tiktok'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['tiktokFollowers'] = account['followerCount'];
//             break;
//           case 'twitter':
//           case 'twitter/x':
//             transformed['twitter'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['twitterFollowers'] = account['followerCount'];
//             break;
//           case 'facebook':
//             transformed['facebook'] =
//                 account['username'] ?? account['profileUrl'];
//             break;
//           case 'linkedin':
//             transformed['linkedin'] =
//                 account['username'] ?? account['profileUrl'];
//             break;
//         }
//       }

//       // Set calculated totals
//       transformed['followers'] = totalFollowers;
//       transformed['engagement'] =
//           accountsWithEngagement > 0
//               ? (totalEngagement / accountsWithEngagement).round()
//               : 0;
//     }

//     // Extract performance metrics
//     if (rawData['performanceMetrics'] != null) {
//       Map<String, dynamic> metrics = rawData['performanceMetrics'];
//       transformed['followers'] =
//           metrics['totalFollowers'] ?? transformed['followers'] ?? 0;
//       transformed['engagement'] =
//           metrics['averageEngagementRate']?.round() ??
//           transformed['engagement'] ??
//           0;
//       transformed['avgViews'] = metrics['averageViews'];
//       transformed['pastCampaigns'] = metrics['pastCampaigns'];
//     }

//     // Extract professional info
//     if (rawData['professionalInfo'] != null) {
//       Map<String, dynamic> professional = rawData['professionalInfo'];

//       if (professional['rateCard'] != null) {
//         Map<String, dynamic> rateCard = professional['rateCard'];
//         transformed['postRate'] = rateCard['postRate'];
//         transformed['storyRate'] = rateCard['storyRate'];
//         transformed['videoRate'] = rateCard['videoRate'];
//         transformed['reelRate'] = rateCard['reelRate'];
//       }

//       transformed['pastCollaborationBrands'] =
//           professional['pastCollaborationBrands'];
//       transformed['brandsWorkedWith'] =
//           professional['pastCollaborationBrands']?.length ?? 0;
//     }

//     // Extract additional info
//     if (rawData['additionalInfo'] != null) {
//       Map<String, dynamic> additional = rawData['additionalInfo'];
//       transformed['gstNumber'] = additional['gstNumber'];
//       transformed['panNumber'] = additional['panNumber'];
//       transformed['paymentMethod'] = additional['paymentMethod'];
//     }

//     // Flatten basic fields
//     transformed['fullName'] = rawData['fullName'];
//     transformed['phone'] = rawData['phoneNumber'];
//     transformed['location'] =
//         '${rawData['city'] ?? ''}, ${rawData['country'] ?? ''}'
//             .trim()
//             .replaceAll(RegExp(r'^,|,$'), '');
//     transformed['category'] =
//         rawData['categories']?.isNotEmpty == true
//             ? rawData['categories'][0]
//             : 'General';
//     transformed['categories'] = rawData['categories'];
//     transformed['language'] =
//         rawData['languagesSpoken']?.isNotEmpty == true
//             ? rawData['languagesSpoken'].join(', ')
//             : null;
//     transformed['skills'] =
//         rawData['categories']; // Use categories as skills for now
//     transformed['interests'] =
//         rawData['categories']; // Use categories as interests for now

//     // Add some default metrics if missing
//     transformed['posts'] = transformed['posts'] ?? 50; // Default value
//     transformed['reach'] =
//         transformed['reach'] ??
//         (transformed['followers'] * 2); // Estimate reach
//     transformed['avgLikes'] =
//         transformed['avgLikes'] ??
//         ((transformed['followers'] * (transformed['engagement'] ?? 3)) / 100)
//             .round();
//     transformed['avgComments'] =
//         transformed['avgComments'] ?? (transformed['avgLikes'] / 10).round();
//     transformed['avgShares'] =
//         transformed['avgShares'] ?? (transformed['avgLikes'] / 20).round();
//     transformed['postFrequency'] = transformed['postFrequency'] ?? 'Daily';
//     transformed['responseRate'] = transformed['responseRate'] ?? 95;

//     // Audience analytics (estimated based on category and location)
//     transformed['audienceAge'] = _getAudienceAgeByCategory(
//       transformed['category'],
//     );
//     transformed['audienceGender'] = _getAudienceGenderByCategory(
//       transformed['category'],
//     );
//     transformed['audienceLocation'] = transformed['location'];
//     transformed['audienceInterests'] = transformed['category'];

//     // Collaboration metrics
//     transformed['totalCollaborations'] =
//         transformed['totalCollaborations'] ?? 5;
//     transformed['completedProjects'] = transformed['completedProjects'] ?? 4;
//     transformed['avgRating'] = transformed['avgRating'] ?? 4.5;

//     print('Transformed data: $transformed');
//     return transformed;
//   }

//   String _getAudienceAgeByCategory(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'gaming':
//       case 'tech':
//         return '18-25';
//       case 'fashion':
//       case 'beauty':
//         return '20-30';
//       case 'fitness':
//       case 'health':
//         return '25-35';
//       case 'business':
//       case 'education':
//         return '25-40';
//       default:
//         return '18-35';
//     }
//   }

//   String _getAudienceGenderByCategory(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'fashion':
//       case 'beauty':
//         return '70% Female, 30% Male';
//       case 'gaming':
//       case 'tech':
//         return '65% Male, 35% Female';
//       case 'fitness':
//       case 'health':
//         return '55% Female, 45% Male';
//       default:
//         return '50% Female, 50% Male';
//     }
//   }

//   String formatNumber(dynamic number) {
//     if (number == null) return '0';
//     int num = int.tryParse(number.toString()) ?? 0;
//     if (num >= 1000000) {
//       return '${(num / 1000000).toStringAsFixed(1)}M';
//     } else if (num >= 1000) {
//       return '${(num / 1000).toStringAsFixed(1)}K';
//     }
//     return num.toString();
//   }

//   void clearData() {
//     _influencerData = null;
//     _isLoading = true;
//     _isUpdating = false;
//     _error = null;
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/MessageProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:flutter/material.dart';

class InfluencerDetailProvider extends ChangeNotifier {
  Map<String, dynamic>? _influencerData;
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _error;

  Map<String, dynamic>? get influencerData => _influencerData;
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get error => _error;

  Future<void> loadInfluencerDetails(ApplicationModel application) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Loading influencer details for ID: ${application.influencerId}');

      // First, try to get from 'influencers' collection
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('influencers')
              .doc(application.influencerId)
              .get();

      if (doc.exists) {
        print('Found in influencers collection: ${doc.data()}');
        final rawData = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> transformedData = _transformInfluencerData(
          rawData,
        );
        _influencerData = transformedData;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // If not found, try 'users' collection
      doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(application.influencerId)
              .get();

      if (doc.exists) {
        print('Found in users collection: ${doc.data()}');
        final rawData = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> transformedData = _transformInfluencerData(
          rawData,
        );
        _influencerData = transformedData;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Try querying by email in influencers collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('influencers')
              .where('email', isEqualTo: application.influencerEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Found by email query: ${querySnapshot.docs.first.data()}');
        final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        Map<String, dynamic> transformedData = _transformInfluencerData(
          rawData,
        );
        _influencerData = transformedData;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Try users collection by email
      querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: application.influencerEmail)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Found in users by email: ${querySnapshot.docs.first.data()}');
        final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        Map<String, dynamic> transformedData = _transformInfluencerData(
          rawData,
        );
        _influencerData = transformedData;
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('No influencer data found in any collection');
      _influencerData = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading influencer details: $e');
      _error = 'Failed to load influencer details';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateApplicationStatusAndSendMessage({
    required String applicationId,
    required String status,
    required ApplicationModel application,
    required MessageProvider messageProvider,
  }) async {
    _isUpdating = true;
    notifyListeners();

    try {
      if (status == 'accepted') {
        // Get brand name from Firestore
        final brandDoc =
            await FirebaseFirestore.instance
                .collection('brands')
                .doc(application.brandId)
                .get();

        final brandName = brandDoc.data()?['brandName'] ?? 'Brand Team';

        // Send acceptance message via MessageProvider
        final messageSuccess = await messageProvider.sendAcceptanceMessage(
          application: application,
          brandName: brandName,
          campaignTitle: application.campaignTitle,
        );

        if (!messageSuccess) {
          throw Exception('Failed to send acceptance message');
        }
      } else {
        // For rejection, just update the status
        await FirebaseFirestore.instance
            .collection('applications')
            .doc(applicationId)
            .update({'status': status, 'respondedAt': DateTime.now()});
      }

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating application status: $e');
      _error = 'Failed to update application status';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // Keep the existing updateApplicationStatus for backward compatibility
  Future<bool> updateApplicationStatus(
    String applicationId,
    String status,
  ) async {
    _isUpdating = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('applications')
          .doc(applicationId)
          .update({'status': status, 'respondedAt': DateTime.now()});

      _isUpdating = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating application status: $e');
      _error = 'Failed to update application status';
      _isUpdating = false;
      notifyListeners();
      return false;
    }
  }

  // ... rest of your existing methods remain the same ...
  Map<String, dynamic> _transformInfluencerData(Map<String, dynamic> rawData) {
    // Your existing transformation logic
    Map<String, dynamic> transformed = Map.from(rawData);

    // Extract social media data and calculate totals
    if (rawData['socialMediaAccounts'] != null) {
      List<dynamic> socialAccounts = rawData['socialMediaAccounts'];
      int totalFollowers = 0;
      double totalEngagement = 0.0;
      int accountsWithEngagement = 0;

      for (var account in socialAccounts) {
        String platform = account['platform']?.toLowerCase() ?? '';

        // Add follower counts
        if (account['followerCount'] != null) {
          totalFollowers += (account['followerCount'] as int);
        }

        // Add engagement rates
        if (account['engagementRate'] != null) {
          totalEngagement += (account['engagementRate'] as double);
          accountsWithEngagement++;
        }

        // Extract platform-specific data
        switch (platform) {
          case 'instagram':
            transformed['instagram'] =
                account['username'] ?? account['profileUrl'];
            transformed['instagramFollowers'] = account['followerCount'];
            transformed['instagramEngagement'] = account['engagementRate'];
            break;
          case 'youtube':
            transformed['youtube'] =
                account['username'] ?? account['channelLink'];
            transformed['youtubeFollowers'] = account['followerCount'];
            transformed['youtubeViews'] = account['avgViews'];
            break;
          case 'tiktok':
            transformed['tiktok'] =
                account['username'] ?? account['profileUrl'];
            transformed['tiktokFollowers'] = account['followerCount'];
            break;
          case 'twitter':
          case 'twitter/x':
            transformed['twitter'] =
                account['username'] ?? account['profileUrl'];
            transformed['twitterFollowers'] = account['followerCount'];
            break;
          case 'facebook':
            transformed['facebook'] =
                account['username'] ?? account['profileUrl'];
            break;
          case 'linkedin':
            transformed['linkedin'] =
                account['username'] ?? account['profileUrl'];
            break;
        }
      }

      // Set calculated totals
      transformed['followers'] = totalFollowers;
      transformed['engagement'] =
          accountsWithEngagement > 0
              ? (totalEngagement / accountsWithEngagement).round()
              : 0;
    }

    // Extract performance metrics
    if (rawData['performanceMetrics'] != null) {
      Map<String, dynamic> metrics = rawData['performanceMetrics'];
      transformed['followers'] =
          metrics['totalFollowers'] ?? transformed['followers'] ?? 0;
      transformed['engagement'] =
          metrics['averageEngagementRate']?.round() ??
          transformed['engagement'] ??
          0;
      transformed['avgViews'] = metrics['averageViews'];
      transformed['pastCampaigns'] = metrics['pastCampaigns'];
    }

    // Extract professional info
    if (rawData['professionalInfo'] != null) {
      Map<String, dynamic> professional = rawData['professionalInfo'];

      if (professional['rateCard'] != null) {
        Map<String, dynamic> rateCard = professional['rateCard'];
        transformed['postRate'] = rateCard['postRate'];
        transformed['storyRate'] = rateCard['storyRate'];
        transformed['videoRate'] = rateCard['videoRate'];
        transformed['reelRate'] = rateCard['reelRate'];
      }

      transformed['pastCollaborationBrands'] =
          professional['pastCollaborationBrands'];
      transformed['brandsWorkedWith'] =
          professional['pastCollaborationBrands']?.length ?? 0;
    }

    // Extract additional info
    if (rawData['additionalInfo'] != null) {
      Map<String, dynamic> additional = rawData['additionalInfo'];
      transformed['gstNumber'] = additional['gstNumber'];
      transformed['panNumber'] = additional['panNumber'];
      transformed['paymentMethod'] = additional['paymentMethod'];
    }

    // Flatten basic fields
    transformed['fullName'] = rawData['fullName'];
    transformed['phone'] = rawData['phoneNumber'];
    transformed['location'] =
        '${rawData['city'] ?? ''}, ${rawData['country'] ?? ''}'
            .trim()
            .replaceAll(RegExp(r'^,|,$'), '');
    transformed['category'] =
        rawData['categories']?.isNotEmpty == true
            ? rawData['categories'][0]
            : 'General';
    transformed['categories'] = rawData['categories'];
    transformed['language'] =
        rawData['languagesSpoken']?.isNotEmpty == true
            ? rawData['languagesSpoken'].join(', ')
            : null;
    transformed['skills'] =
        rawData['categories']; // Use categories as skills for now
    transformed['interests'] =
        rawData['categories']; // Use categories as interests for now

    // Add some default metrics if missing
    transformed['posts'] = transformed['posts'] ?? 50; // Default value
    transformed['reach'] =
        transformed['reach'] ??
        (transformed['followers'] * 2); // Estimate reach
    transformed['avgLikes'] =
        transformed['avgLikes'] ??
        ((transformed['followers'] * (transformed['engagement'] ?? 3)) / 100)
            .round();
    transformed['avgComments'] =
        transformed['avgComments'] ?? (transformed['avgLikes'] / 10).round();
    transformed['avgShares'] =
        transformed['avgShares'] ?? (transformed['avgLikes'] / 20).round();
    transformed['postFrequency'] = transformed['postFrequency'] ?? 'Daily';
    transformed['responseRate'] = transformed['responseRate'] ?? 95;

    // Audience analytics (estimated based on category and location)
    transformed['audienceAge'] = _getAudienceAgeByCategory(
      transformed['category'],
    );
    transformed['audienceGender'] = _getAudienceGenderByCategory(
      transformed['category'],
    );
    transformed['audienceLocation'] = transformed['location'];
    transformed['audienceInterests'] = transformed['category'];

    // Collaboration metrics
    transformed['totalCollaborations'] =
        transformed['totalCollaborations'] ?? 5;
    transformed['completedProjects'] = transformed['completedProjects'] ?? 4;
    transformed['avgRating'] = transformed['avgRating'] ?? 4.5;

    print('Transformed data: $transformed');
    return transformed;
  }

  String _getAudienceAgeByCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'gaming':
      case 'tech':
        return '18-25';
      case 'fashion':
      case 'beauty':
        return '20-30';
      case 'fitness':
      case 'health':
        return '25-35';
      case 'business':
      case 'education':
        return '25-40';
      default:
        return '18-35';
    }
  }

  String _getAudienceGenderByCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'fashion':
      case 'beauty':
        return '70% Female, 30% Male';
      case 'gaming':
      case 'tech':
        return '65% Male, 35% Female';
      case 'fitness':
      case 'health':
        return '55% Female, 45% Male';
      default:
        return '50% Female, 50% Male';
    }
  }

  String formatNumber(dynamic number) {
    if (number == null) return '0';
    int num = int.tryParse(number.toString()) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }

  void clearData() {
    _influencerData = null;
    _isLoading = true;
    _isUpdating = false;
    _error = null;
  }
}
