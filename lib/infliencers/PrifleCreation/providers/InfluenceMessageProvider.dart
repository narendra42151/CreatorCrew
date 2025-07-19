// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class InfluencerMessageProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   bool _isLoading = false;
//   bool _isSending = false;
//   List<InfluencerChatRoom> _chatRooms = [];
//   List<InfluencerMessage> _messages = [];

//   bool get isLoading => _isLoading;
//   bool get isSending => _isSending;
//   List<InfluencerChatRoom> get chatRooms => _chatRooms;
//   List<InfluencerMessage> get messages => _messages;

//   // Fetch chat rooms for current influencer
//   Future<void> fetchChatRooms() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final currentUser = _auth.currentUser;
//       if (currentUser == null) {
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       print('Fetching chat rooms for influencer: ${currentUser.uid}');

//       // Query chat rooms where current user is the influencer
//       final snapshot =
//           await _firestore
//               .collection('chatRooms')
//               .where('influencerId', isEqualTo: currentUser.uid)
//               .get();

//       print('Found ${snapshot.docs.length} chat rooms');

//       List<InfluencerChatRoom> chatRooms = [];

//       for (var doc in snapshot.docs) {
//         try {
//           final chatRoom = InfluencerChatRoom.fromFirestore(doc);

//           // Get unread count for this chat room
//           final unreadCount = await _getUnreadCount(doc.id, currentUser.uid);
//           chatRoom.unreadCount = unreadCount;

//           chatRooms.add(chatRoom);
//         } catch (e) {
//           print('Error parsing chat room ${doc.id}: $e');
//         }
//       }

//       // Sort by last message time (most recent first)
//       chatRooms.sort((a, b) {
//         if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
//         if (a.lastMessageTime == null) return 1;
//         if (b.lastMessageTime == null) return -1;
//         return b.lastMessageTime!.compareTo(a.lastMessageTime!);
//       });

//       _chatRooms = chatRooms;
//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching chat rooms: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Get unread message count for a chat room
//   Future<int> _getUnreadCount(String chatRoomId, String currentUserId) async {
//     try {
//       final snapshot =
//           await _firestore
//               .collection('chatRooms')
//               .doc(chatRoomId)
//               .collection('messages')
//               .where('receiverId', isEqualTo: currentUserId)
//               .where('isRead', isEqualTo: false)
//               .get();

//       return snapshot.docs.length;
//     } catch (e) {
//       print('Error getting unread count: $e');
//       return 0;
//     }
//   }

//   // Send message
//   Future<bool> sendMessage({
//     required String chatRoomId,
//     required String receiverId,
//     required String receiverName,
//     required String message,
//   }) async {
//     try {
//       _isSending = true;
//       notifyListeners();

//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return false;

//       // Get influencer name from user profile
//       final userDoc =
//           await _firestore.collection('influencers').doc(currentUser.uid).get();

//       String senderName = 'Influencer';
//       if (userDoc.exists) {
//         senderName = userDoc.data()?['fullName'] ?? 'Influencer';
//       }

//       await _sendMessage(
//         chatRoomId: chatRoomId,
//         senderId: currentUser.uid,
//         senderName: senderName,
//         receiverId: receiverId,
//         receiverName: receiverName,
//         message: message,
//         messageType: 'text',
//       );

//       _isSending = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       print('Error sending message: $e');
//       _isSending = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Internal method to send message
//   Future<void> _sendMessage({
//     required String chatRoomId,
//     required String senderId,
//     required String senderName,
//     required String receiverId,
//     required String receiverName,
//     required String message,
//     required String messageType,
//   }) async {
//     final messageRef =
//         _firestore
//             .collection('chatRooms')
//             .doc(chatRoomId)
//             .collection('messages')
//             .doc();

//     await messageRef.set({
//       'id': messageRef.id,
//       'senderId': senderId,
//       'senderName': senderName,
//       'receiverId': receiverId,
//       'receiverName': receiverName,
//       'message': message,
//       'messageType': messageType,
//       'timestamp': FieldValue.serverTimestamp(),
//       'isRead': false,
//     });

//     // Update chat room with last message
//     await _firestore.collection('chatRooms').doc(chatRoomId).update({
//       'lastMessage':
//           message.length > 50 ? '${message.substring(0, 50)}...' : message,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     });
//   }

//   // Get messages stream for a specific chat room
//   Stream<List<InfluencerMessage>> getMessagesStream(String chatRoomId) {
//     return _firestore
//         .collection('chatRooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) =>
//               snapshot.docs
//                   .map((doc) => InfluencerMessage.fromFirestore(doc))
//                   .toList(),
//         );
//   }

//   // Mark messages as read
//   Future<void> markMessagesAsRead(String chatRoomId) async {
//     try {
//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return;

//       final messagesRef = _firestore
//           .collection('chatRooms')
//           .doc(chatRoomId)
//           .collection('messages');

//       final unreadMessages =
//           await messagesRef
//               .where('receiverId', isEqualTo: currentUser.uid)
//               .where('isRead', isEqualTo: false)
//               .get();

//       final batch = _firestore.batch();
//       for (final doc in unreadMessages.docs) {
//         batch.update(doc.reference, {'isRead': true});
//       }
//       await batch.commit();

//       // Refresh chat rooms to update unread counts
//       fetchChatRooms();
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }

//   // Send availability response
//   Future<bool> sendAvailabilityResponse({
//     required String chatRoomId,
//     required String receiverId,
//     required String receiverName,
//     required String availability,
//     required String preferredFormat,
//   }) async {
//     final message = """
// 📅 Meeting Availability Response

// Thank you for accepting my application! I'm excited to discuss the collaboration details.

// My Availability:
// $availability

// Preferred Meeting Format: $preferredFormat

// I'm looking forward to our discussion and learning more about the campaign requirements.

// Best regards!
// """;

//     return await sendMessage(
//       chatRoomId: chatRoomId,
//       receiverId: receiverId,
//       receiverName: receiverName,
//       message: message,
//     );
//   }
// }

// // Models
// class InfluencerChatRoom {
//   final String id;
//   final String brandId;
//   final String influencerId;
//   final String brandName;
//   final String influencerName;
//   final String campaignTitle;
//   final DateTime createdAt;
//   final String lastMessage;
//   final DateTime? lastMessageTime;
//   final bool isActive;
//   final String messageType;
//   int unreadCount;

//   InfluencerChatRoom({
//     required this.id,
//     required this.brandId,
//     required this.influencerId,
//     required this.brandName,
//     required this.influencerName,
//     required this.campaignTitle,
//     required this.createdAt,
//     required this.lastMessage,
//     this.lastMessageTime,
//     required this.isActive,
//     this.messageType = 'text',
//     this.unreadCount = 0,
//   });

//   factory InfluencerChatRoom.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return InfluencerChatRoom(
//       id: doc.id,
//       brandId: data['brandId'] ?? '',
//       influencerId: data['influencerId'] ?? '',
//       brandName: data['brandName'] ?? '',
//       influencerName: data['influencerName'] ?? '',
//       campaignTitle: data['campaignTitle'] ?? '',
//       createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       lastMessage: data['lastMessage'] ?? '',
//       lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
//       isActive: data['isActive'] ?? true,
//       messageType: data['messageType'] ?? 'text',
//     );
//   }
// }

// class InfluencerMessage {
//   final String id;
//   final String senderId;
//   final String senderName;
//   final String receiverId;
//   final String receiverName;
//   final String message;
//   final String messageType;
//   final DateTime timestamp;
//   final bool isRead;
//   final String? campaignId;

//   InfluencerMessage({
//     required this.id,
//     required this.senderId,
//     required this.senderName,
//     required this.receiverId,
//     required this.receiverName,
//     required this.message,
//     required this.messageType,
//     required this.timestamp,
//     required this.isRead,
//     this.campaignId,
//   });

//   factory InfluencerMessage.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return InfluencerMessage(
//       id: doc.id,
//       senderId: data['senderId'] ?? '',
//       senderName: data['senderName'] ?? '',
//       receiverId: data['receiverId'] ?? '',
//       receiverName: data['receiverName'] ?? '',
//       message: data['message'] ?? '',
//       messageType: data['messageType'] ?? 'text',
//       timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       isRead: data['isRead'] ?? false,
//       campaignId: data['campaignId'],
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfluencerMessageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isSending = false;
  List<InfluencerChatRoom> _chatRooms = [];
  List<InfluencerMessage> _messages = [];

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  List<InfluencerChatRoom> get chatRooms => _chatRooms;
  List<InfluencerMessage> get messages => _messages;

  // Add this getter to expose current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Fetch chat rooms for current influencer
  Future<void> fetchChatRooms() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      print('Fetching chat rooms for influencer: ${currentUser.uid}');

      // Query chat rooms where current user is the influencer
      final snapshot =
          await _firestore
              .collection('chatRooms')
              .where('influencerId', isEqualTo: currentUser.uid)
              .get();

      print('Found ${snapshot.docs.length} chat rooms');

      List<InfluencerChatRoom> chatRooms = [];

      for (var doc in snapshot.docs) {
        try {
          final chatRoom = InfluencerChatRoom.fromFirestore(doc);

          // Get unread count for this chat room
          final unreadCount = await _getUnreadCount(doc.id, currentUser.uid);
          chatRoom.unreadCount = unreadCount;

          chatRooms.add(chatRoom);
        } catch (e) {
          print('Error parsing chat room ${doc.id}: $e');
        }
      }

      // Sort by last message time (most recent first)
      chatRooms.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      _chatRooms = chatRooms;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching chat rooms: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get unread message count for a chat room
  Future<int> _getUnreadCount(String chatRoomId, String currentUserId) async {
    try {
      final snapshot =
          await _firestore
              .collection('chatRooms')
              .doc(chatRoomId)
              .collection('messages')
              .where('receiverId', isEqualTo: currentUserId)
              .where('isRead', isEqualTo: false)
              .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  // Send message
  Future<bool> sendMessage({
    required String chatRoomId,
    required String receiverId,
    required String receiverName,
    required String message,
  }) async {
    try {
      _isSending = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get influencer name from user profile
      final userDoc =
          await _firestore.collection('influencers').doc(currentUser.uid).get();

      String senderName = 'Influencer';
      if (userDoc.exists) {
        senderName = userDoc.data()?['fullName'] ?? 'Influencer';
      }

      await _sendMessage(
        chatRoomId: chatRoomId,
        senderId: currentUser.uid,
        senderName: senderName,
        receiverId: receiverId,
        receiverName: receiverName,
        message: message,
        messageType: 'text',
      );

      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error sending message: $e');
      _isSending = false;
      notifyListeners();
      return false;
    }
  }

  // Internal method to send message
  Future<void> _sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String message,
    required String messageType,
  }) async {
    final messageRef =
        _firestore
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection('messages')
            .doc();

    await messageRef.set({
      'id': messageRef.id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'message': message,
      'messageType': messageType,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Update chat room with last message
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage':
          message.length > 50 ? '${message.substring(0, 50)}...' : message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get messages stream for a specific chat room
  Stream<List<InfluencerMessage>> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => InfluencerMessage.fromFirestore(doc))
                  .toList(),
        );
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      final messagesRef = _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages');

      final unreadMessages =
          await messagesRef
              .where('receiverId', isEqualTo: currentUser.uid)
              .where('isRead', isEqualTo: false)
              .get();

      final batch = _firestore.batch();
      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      // Refresh chat rooms to update unread counts
      fetchChatRooms();
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Send availability response
  Future<bool> sendAvailabilityResponse({
    required String chatRoomId,
    required String receiverId,
    required String receiverName,
    required String availability,
    required String preferredFormat,
  }) async {
    final message = """
📅 Meeting Availability Response

Thank you for accepting my application! I'm excited to discuss the collaboration details.

My Availability:
$availability

Preferred Meeting Format: $preferredFormat

I'm looking forward to our discussion and learning more about the campaign requirements.

Best regards!
""";

    return await sendMessage(
      chatRoomId: chatRoomId,
      receiverId: receiverId,
      receiverName: receiverName,
      message: message,
    );
  }
}

// Models
class InfluencerChatRoom {
  final String id;
  final String brandId;
  final String influencerId;
  final String brandName;
  final String influencerName;
  final String campaignTitle;
  final DateTime createdAt;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final bool isActive;
  final String messageType;
  int unreadCount;

  InfluencerChatRoom({
    required this.id,
    required this.brandId,
    required this.influencerId,
    required this.brandName,
    required this.influencerName,
    required this.campaignTitle,
    required this.createdAt,
    required this.lastMessage,
    this.lastMessageTime,
    required this.isActive,
    this.messageType = 'text',
    this.unreadCount = 0,
  });

  factory InfluencerChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InfluencerChatRoom(
      id: doc.id,
      brandId: data['brandId'] ?? '',
      influencerId: data['influencerId'] ?? '',
      brandName: data['brandName'] ?? '',
      influencerName: data['influencerName'] ?? '',
      campaignTitle: data['campaignTitle'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      messageType: data['messageType'] ?? 'text',
    );
  }
}

class InfluencerMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String message;
  final String messageType;
  final DateTime timestamp;
  final bool isRead;
  final String? campaignId;

  InfluencerMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.message,
    required this.messageType,
    required this.timestamp,
    required this.isRead,
    this.campaignId,
  });

  factory InfluencerMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InfluencerMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      receiverId: data['receiverId'] ?? '',
      receiverName: data['receiverName'] ?? '',
      message: data['message'] ?? '',
      messageType: data['messageType'] ?? 'text',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: data['isRead'] ?? false,
      campaignId: data['campaignId'],
    );
  }
}
