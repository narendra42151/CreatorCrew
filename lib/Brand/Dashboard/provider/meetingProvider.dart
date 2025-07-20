// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// class MeetingProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   bool _isLoading = false;
//   bool _isScheduling = false;
//   List<Meeting> _meetings = [];
//   List<TimeSlot> _availableSlots = [];

//   bool get isLoading => _isLoading;
//   bool get isScheduling => _isScheduling;
//   List<Meeting> get meetings => _meetings;
//   List<TimeSlot> get availableSlots => _availableSlots;

//   String? get currentUserId => _auth.currentUser?.uid;

//   // Schedule a new meeting
//   Future<bool> scheduleMeeting({
//     required String chatRoomId,
//     required String brandId,
//     required String influencerId,
//     required String brandName,
//     required String influencerName,
//     required String campaignTitle,
//     required DateTime scheduledDateTime,
//     required int durationMinutes,
//     required MeetingType type,
//     String? agenda,
//     Map<String, dynamic>? settings,
//   }) async {
//     try {
//       _isScheduling = true;
//       notifyListeners();

//       final meetingId = Uuid().v4();
//       final meeting = Meeting(
//         id: meetingId,
//         chatRoomId: chatRoomId,
//         brandId: brandId,
//         influencerId: influencerId,
//         brandName: brandName,
//         influencerName: influencerName,
//         campaignTitle: campaignTitle,
//         scheduledDateTime: scheduledDateTime,
//         durationMinutes: durationMinutes,
//         type: type,
//         status: MeetingStatus.scheduled,
//         agenda: agenda,
//         createdAt: DateTime.now(),
//         attendees: [brandId, influencerId],
//         meetingSettings: settings,
//       );

//       // Generate meeting link for video calls
//       if (type == MeetingType.video) {
//         final meetingLink = await _generateMeetingLink(meetingId);
//         final updatedMeeting = Meeting(
//           id: meeting.id,
//           chatRoomId: meeting.chatRoomId,
//           brandId: meeting.brandId,
//           influencerId: meeting.influencerId,
//           brandName: meeting.brandName,
//           influencerName: meeting.influencerName,
//           campaignTitle: meeting.campaignTitle,
//           scheduledDateTime: meeting.scheduledDateTime,
//           durationMinutes: meeting.durationMinutes,
//           type: meeting.type,
//           status: meeting.status,
//           meetingLink: meetingLink,
//           agenda: meeting.agenda,
//           createdAt: meeting.createdAt,
//           attendees: meeting.attendees,
//           meetingSettings: meeting.meetingSettings,
//         );

//         await _firestore
//             .collection('meetings')
//             .doc(meetingId)
//             .set(updatedMeeting.toFirestore());
//       } else {
//         await _firestore
//             .collection('meetings')
//             .doc(meetingId)
//             .set(meeting.toFirestore());
//       }

//       // Send meeting notification message
//       await _sendMeetingNotification(meeting);

//       _isScheduling = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       print('Error scheduling meeting: $e');
//       _isScheduling = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Generate meeting link (you can integrate with Jitsi, Zoom, or custom solution)
//   Future<String> _generateMeetingLink(String meetingId) async {
//     // For demo purposes, using Jitsi Meet
//     return 'https://meet.jit.si/CreatorCrew-$meetingId';
//   }

//   // Send meeting notification
//   Future<void> _sendMeetingNotification(Meeting meeting) async {
//     final messageRef =
//         _firestore
//             .collection('chatRooms')
//             .doc(meeting.chatRoomId)
//             .collection('messages')
//             .doc();

//     final notificationMessage = """
// 📅 Meeting Scheduled!

// Meeting Details:
// • Date: ${_formatDate(meeting.scheduledDateTime)}
// • Time: ${_formatTime(meeting.scheduledDateTime)}
// • Duration: ${meeting.durationMinutes} minutes
// • Type: ${_getMeetingTypeText(meeting.type)}
// ${meeting.meetingLink != null ? '• Meeting Link: ${meeting.meetingLink}' : ''}
// ${meeting.agenda != null ? '• Agenda: ${meeting.agenda}' : ''}

// Campaign: ${meeting.campaignTitle}

// Looking forward to our discussion! 🚀
// """;

//     await messageRef.set({
//       'id': messageRef.id,
//       'senderId': meeting.brandId,
//       'senderName': meeting.brandName,
//       'receiverId': meeting.influencerId,
//       'receiverName': meeting.influencerName,
//       'message': notificationMessage,
//       'messageType': 'meeting_scheduled',
//       'timestamp': FieldValue.serverTimestamp(),
//       'isRead': false,
//       'meetingId': meeting.id,
//     });

//     // Update chat room
//     await _firestore.collection('chatRooms').doc(meeting.chatRoomId).update({
//       'lastMessage':
//           'Meeting scheduled for ${_formatDate(meeting.scheduledDateTime)}',
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     });
//   }

//   // Fetch meetings for current user
//   Future<void> fetchMeetings() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return;

//       final snapshot =
//           await _firestore
//               .collection('meetings')
//               .where('attendees', arrayContains: currentUser.uid)
//               .orderBy('scheduledDateTime', descending: false)
//               .get();

//       _meetings =
//           snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching meetings: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Get meetings stream
//   Stream<List<Meeting>> getMeetingsStream() {
//     final currentUser = _auth.currentUser;
//     if (currentUser == null) return Stream.value([]);

//     return _firestore
//         .collection('meetings')
//         .where('attendees', arrayContains: currentUser.uid)
//         .orderBy('scheduledDateTime', descending: false)
//         .snapshots()
//         .map(
//           (snapshot) =>
//               snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList(),
//         );
//   }

//   // Update meeting status
//   Future<bool> updateMeetingStatus(
//     String meetingId,
//     MeetingStatus status,
//   ) async {
//     try {
//       await _firestore.collection('meetings').doc(meetingId).update({
//         'status': status.toString().split('.').last,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//       return true;
//     } catch (e) {
//       print('Error updating meeting status: $e');
//       return false;
//     }
//   }

//   // Cancel meeting
//   Future<bool> cancelMeeting(String meetingId, String reason) async {
//     try {
//       await _firestore.collection('meetings').doc(meetingId).update({
//         'status': MeetingStatus.cancelled.toString().split('.').last,
//         'notes': reason,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Send cancellation notification
//       // Implementation similar to scheduling notification

//       return true;
//     } catch (e) {
//       print('Error cancelling meeting: $e');
//       return false;
//     }
//   }

//   // Generate available time slots
//   List<TimeSlot> generateTimeSlots(DateTime date, {int intervalMinutes = 30}) {
//     List<TimeSlot> slots = [];
//     final startHour = 9; // 9 AM
//     final endHour = 18; // 6 PM

//     for (int hour = startHour; hour < endHour; hour++) {
//       for (int minute = 0; minute < 60; minute += intervalMinutes) {
//         final startTime = DateTime(
//           date.year,
//           date.month,
//           date.day,
//           hour,
//           minute,
//         );
//         final endTime = startTime.add(Duration(minutes: intervalMinutes));

//         if (endTime.hour <= endHour) {
//           slots.add(TimeSlot(startTime: startTime, endTime: endTime));
//         }
//       }
//     }

//     return slots;
//   }

//   // Helper methods
//   String _formatDate(DateTime date) {
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return '${date.day} ${months[date.month - 1]}, ${date.year}';
//   }

//   String _formatTime(DateTime time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }

//   String _getMeetingTypeText(MeetingType type) {
//     switch (type) {
//       case MeetingType.video:
//         return 'Video Call';
//       case MeetingType.audio:
//         return 'Audio Call';
//       case MeetingType.phone:
//         return 'Phone Call';
//       case MeetingType.inPerson:
//         return 'In-Person Meeting';
//     }
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MeetingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isScheduling = false;
  List<Meeting> _meetings = [];
  List<TimeSlot> _availableSlots = [];

  bool get isLoading => _isLoading;
  bool get isScheduling => _isScheduling;
  List<Meeting> get meetings => _meetings;
  List<TimeSlot> get availableSlots => _availableSlots;

  String? get currentUserId => _auth.currentUser?.uid;

  // Fetch all meetings for current brand
  Future<void> fetchBrandMeetings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('Fetching meetings for brand: ${currentUser.uid}');

      final snapshot =
          await _firestore
              .collection('meetings')
              .where('brandId', isEqualTo: currentUser.uid)
              .get();

      _meetings =
          snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();

      print('Found ${_meetings.length} meetings');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching meetings: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get meetings stream for real-time updates
  Stream<List<Meeting>> getBrandMeetingsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('meetings')
        .where('brandId', isEqualTo: currentUser.uid)
        .orderBy('scheduledDateTime', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList(),
        );
  }

  // Join meeting
  // ...existing code...

  // Join meeting
  // Future<bool> joinMeeting(String meetingLink) async {
  //   try {
  //     print('Attempting to launch: $meetingLink');

  //     final Uri uri = Uri.parse(meetingLink);

  //     // Check if URL can be launched
  //     if (await canLaunchUrl(uri)) {
  //       // Try external application first
  //       bool launched = await launchUrl(
  //         uri,
  //         mode: LaunchMode.externalApplication,
  //       );

  //       if (!launched) {
  //         // Fallback to in-app browser
  //         launched = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  //       }

  //       print('Meeting link launched: $launched');
  //       return launched;
  //     } else {
  //       print('Cannot launch URL: $meetingLink');
  //       return false;
  //     }
  //   } catch (e) {
  //     print('Error joining meeting: $e');
  //     return false;
  //   }
  // }

  // ...existing code...
  // ...existing imports...

  // Join meeting with improved error handling
  Future<bool> joinMeeting(String meetingLink) async {
    try {
      print('Attempting to launch: $meetingLink');

      final Uri uri = Uri.parse(meetingLink);

      // Try different launch modes in order of preference
      List<LaunchMode> launchModes = [
        LaunchMode.externalApplication,
        LaunchMode.externalNonBrowserApplication,
        LaunchMode.inAppWebView,
        LaunchMode.platformDefault,
      ];

      for (LaunchMode mode in launchModes) {
        try {
          print('Trying launch mode: $mode');

          bool launched = await launchUrl(uri, mode: mode);

          if (launched) {
            print('Successfully launched with mode: $mode');
            return true;
          }
        } catch (e) {
          print('Failed with mode $mode: $e');
          continue;
        }
      }

      // If all modes fail, try without checking canLaunchUrl
      try {
        print('Trying direct launch without canLaunchUrl check');
        bool launched = await launchUrl(uri);
        if (launched) {
          print('Successfully launched with direct method');
          return true;
        }
      } catch (e) {
        print('Direct launch failed: $e');
      }

      print('All launch attempts failed for: $meetingLink');
      return false;
    } catch (e) {
      print('Error joining meeting: $e');
      return false;
    }
  }

  // Alternative method for opening URLs
  Future<bool> openUrlAlternative(String meetingLink) async {
    try {
      // Try to launch with minimal configuration
      return await launchUrl(
        Uri.parse(meetingLink),
        mode: LaunchMode.platformDefault,
      );
    } catch (e) {
      print('Alternative URL opening failed: $e');
      return false;
    }
  }

  Future<bool> updateMeetingStatus(
    String meetingId,
    MeetingStatus status,
  ) async {
    try {
      await _firestore.collection('meetings').doc(meetingId).update({
        'status': status.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Refresh meetings list
      fetchBrandMeetings();
      return true;
    } catch (e) {
      print('Error updating meeting status: $e');
      return false;
    }
  }

  // Cancel meeting
  Future<bool> cancelMeeting(String meetingId, String reason) async {
    try {
      await _firestore.collection('meetings').doc(meetingId).update({
        'status': MeetingStatus.cancelled.toString().split('.').last,
        'notes': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Send cancellation notification
      await _sendCancellationNotification(meetingId, reason);

      fetchBrandMeetings();
      return true;
    } catch (e) {
      print('Error cancelling meeting: $e');
      return false;
    }
  }

  // Send cancellation notification
  Future<void> _sendCancellationNotification(
    String meetingId,
    String reason,
  ) async {
    try {
      final meetingDoc =
          await _firestore.collection('meetings').doc(meetingId).get();
      if (!meetingDoc.exists) return;

      final meeting = Meeting.fromFirestore(meetingDoc);

      final messageRef =
          _firestore
              .collection('chatRooms')
              .doc(meeting.chatRoomId)
              .collection('messages')
              .doc();

      final cancellationMessage = """
❌ Meeting Cancelled

Unfortunately, the meeting scheduled for ${_formatDate(meeting.scheduledDateTime)} at ${_formatTime(meeting.scheduledDateTime)} has been cancelled.

Reason: $reason

Please feel free to reach out to reschedule at your convenience.
""";

      await messageRef.set({
        'id': messageRef.id,
        'senderId': meeting.brandId,
        'senderName': meeting.brandName,
        'receiverId': meeting.influencerId,
        'receiverName': meeting.influencerName,
        'message': cancellationMessage,
        'messageType': 'meeting_cancelled',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'meetingId': meetingId,
      });
    } catch (e) {
      print('Error sending cancellation notification: $e');
    }
  }

  // Get meetings by status
  List<Meeting> getMeetingsByStatus(MeetingStatus status) {
    return _meetings.where((meeting) => meeting.status == status).toList();
  }

  // Get upcoming meetings
  List<Meeting> getUpcomingMeetings() {
    final now = DateTime.now();
    return _meetings
        .where(
          (meeting) =>
              meeting.scheduledDateTime.isAfter(now) &&
              meeting.status == MeetingStatus.scheduled,
        )
        .toList();
  }

  // Get today's meetings
  List<Meeting> getTodaysMeetings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    return _meetings
        .where(
          (meeting) =>
              meeting.scheduledDateTime.isAfter(today) &&
              meeting.scheduledDateTime.isBefore(tomorrow),
        )
        .toList();
  }

  // Check if meeting can be joined (15 minutes before start time)
  bool canJoinMeeting(Meeting meeting) {
    final now = DateTime.now();
    final joinTime = meeting.scheduledDateTime.subtract(Duration(minutes: 15));
    final endTime = meeting.scheduledDateTime.add(
      Duration(minutes: meeting.durationMinutes),
    );

    return now.isAfter(joinTime) &&
        now.isBefore(endTime) &&
        meeting.status == MeetingStatus.scheduled &&
        meeting.meetingLink != null;
  }

  // Check if meeting is starting soon (within 10 minutes)
  bool isMeetingStartingSoon(Meeting meeting) {
    final now = DateTime.now();
    final difference = meeting.scheduledDateTime.difference(now).inMinutes;
    return difference >= 0 && difference <= 10;
  }

  // Add these methods to your existing MeetingProvider class:

  // Fetch all meetings for current influencer
  Future<void> fetchInfluencerMeetings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('Fetching meetings for influencer: ${currentUser.uid}');

      final snapshot =
          await _firestore
              .collection('meetings')
              .where('influencerId', isEqualTo: currentUser.uid)
              .get();

      _meetings =
          snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();

      // Sort by scheduled date time
      _meetings.sort(
        (a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime),
      );

      print('Found ${_meetings.length} meetings for influencer');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching influencer meetings: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get influencer meetings stream for real-time updates
  Stream<List<Meeting>> getInfluencerMeetingsStream() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('meetings')
        .where('influencerId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) {
          final meetings =
              snapshot.docs.map((doc) => Meeting.fromFirestore(doc)).toList();

          // Sort by scheduled date time
          meetings.sort(
            (a, b) => a.scheduledDateTime.compareTo(b.scheduledDateTime),
          );

          return meetings;
        });
  }

  // Check user type and fetch appropriate meetings
  Future<void> fetchUserMeetings() async {
    // You can determine user type based on your app logic
    // For now, I'll assume you have a way to check if user is brand or influencer

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Check if user is brand or influencer
    // This depends on your user data structure
    final userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data();
      final userType =
          userData?['userType'] ?? 'influencer'; // Default to influencer

      if (userType == 'brand') {
        await fetchBrandMeetings();
      } else {
        await fetchInfluencerMeetings();
      }
    } else {
      // Fallback: try both and see which returns results
      await fetchInfluencerMeetings();
      if (_meetings.isEmpty) {
        await fetchBrandMeetings();
      }
    }
  }

  // Schedule a new meeting
  Future<bool> scheduleMeeting({
    required String chatRoomId,
    required String brandId,
    required String influencerId,
    required String brandName,
    required String influencerName,
    required String campaignTitle,
    required DateTime scheduledDateTime,
    required int durationMinutes,
    required MeetingType type,
    String? agenda,
    Map<String, dynamic>? settings,
  }) async {
    try {
      _isScheduling = true;
      notifyListeners();

      final meetingId = Uuid().v4();

      // Generate meeting link for video calls
      String? meetingLink;
      if (type == MeetingType.video) {
        meetingLink = _generateMeetingLink(meetingId);
      }

      final meeting = Meeting(
        id: meetingId,
        chatRoomId: chatRoomId,
        brandId: brandId,
        influencerId: influencerId,
        brandName: brandName,
        influencerName: influencerName,
        campaignTitle: campaignTitle,
        scheduledDateTime: scheduledDateTime,
        durationMinutes: durationMinutes,
        type: type,
        status: MeetingStatus.scheduled,
        meetingLink: meetingLink,
        agenda: agenda,
        createdAt: DateTime.now(),
        attendees: [brandId, influencerId],
        meetingSettings: settings,
      );

      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .set(meeting.toFirestore());

      // Send meeting notification message
      await _sendMeetingNotification(meeting);

      _isScheduling = false;
      notifyListeners();

      // Refresh meetings list
      fetchBrandMeetings();

      return true;
    } catch (e) {
      print('Error scheduling meeting: $e');
      _isScheduling = false;
      notifyListeners();
      return false;
    }
  }

  // Generate meeting link
  String _generateMeetingLink(String meetingId) {
    return 'https://meet.jit.si/CreatorCrew-$meetingId';
  }

  // Send meeting notification
  Future<void> _sendMeetingNotification(Meeting meeting) async {
    final messageRef =
        _firestore
            .collection('chatRooms')
            .doc(meeting.chatRoomId)
            .collection('messages')
            .doc();

    final notificationMessage = """
📅 Meeting Scheduled!

Meeting Details:
• Date: ${_formatDate(meeting.scheduledDateTime)}
• Time: ${_formatTime(meeting.scheduledDateTime)}
• Duration: ${meeting.durationMinutes} minutes
• Type: ${_getMeetingTypeText(meeting.type)}
${meeting.meetingLink != null ? '• Meeting Link: ${meeting.meetingLink}' : ''}
${meeting.agenda != null ? '• Agenda: ${meeting.agenda}' : ''}

Campaign: ${meeting.campaignTitle}

Looking forward to our discussion! 🚀
""";

    await messageRef.set({
      'id': messageRef.id,
      'senderId': meeting.brandId,
      'senderName': meeting.brandName,
      'receiverId': meeting.influencerId,
      'receiverName': meeting.influencerName,
      'message': notificationMessage,
      'messageType': 'meeting_scheduled',
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'meetingId': meeting.id,
    });

    // Update chat room
    await _firestore.collection('chatRooms').doc(meeting.chatRoomId).update({
      'lastMessage':
          'Meeting scheduled for ${_formatDate(meeting.scheduledDateTime)}',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Generate available time slots
  List<TimeSlot> generateTimeSlots(DateTime date, {int intervalMinutes = 30}) {
    List<TimeSlot> slots = [];
    final startHour = 0; // 9 AM
    final endHour = 18; // 6 PM

    for (int hour = startHour; hour < endHour; hour++) {
      for (int minute = 0; minute < 60; minute += intervalMinutes) {
        final startTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
        final endTime = startTime.add(Duration(minutes: intervalMinutes));

        if (endTime.hour <= endHour) {
          slots.add(TimeSlot(startTime: startTime, endTime: endTime));
        }
      }
    }

    return slots;
  }

  // Helper methods
  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getMeetingTypeText(MeetingType type) {
    switch (type) {
      case MeetingType.video:
        return 'Video Call';
      case MeetingType.audio:
        return 'Audio Call';
      case MeetingType.phone:
        return 'Phone Call';
      case MeetingType.inPerson:
        return 'In-Person Meeting';
    }
  }
}
