// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MessageProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   bool _isLoading = false;
//   bool _isSending = false;
//   List<ChatRoom> _chatRooms = [];
//   List<Message> _messages = [];

//   bool get isLoading => _isLoading;
//   bool get isSending => _isSending;
//   List<ChatRoom> get chatRooms => _chatRooms;
//   List<Message> get messages => _messages;

//   // Send acceptance message to influencer
//   Future<bool> sendAcceptanceMessage({
//     required ApplicationModel application,
//     required String brandName,
//     required String campaignTitle,
//   }) async {
//     try {
//       _isSending = true;
//       notifyListeners();

//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return false;

//       // Create or get existing chat room
//       final chatRoomId = _generateChatRoomId(
//         currentUser.uid,
//         application.influencerId,
//       );

//       // Acceptance message template
//       final acceptanceMessage = """
// 🎉 Great news! Your application has been ACCEPTED! 🎉

// Hi ${application.influencerName}!

// We're excited to inform you that your profile is a perfect match for our "${campaignTitle}" campaign. We would love to work with you!

// Your expertise and content style align perfectly with what we're looking for. We believe this collaboration will be amazing!

// 📅 When would you be available for a meeting to discuss the campaign details?

// Please let us know your preferred time slots and we'll coordinate accordingly.

// Looking forward to working together! 🚀

// Best regards,
// ${brandName} Team
// """;

//       // Create chat room if it doesn't exist
//       await _createOrUpdateChatRoom(
//         chatRoomId: chatRoomId,
//         brandId: currentUser.uid,
//         influencerId: application.influencerId,
//         brandName: brandName,
//         influencerName: application.influencerName,
//         campaignTitle: campaignTitle,
//       );

//       // Send the acceptance message
//       await _sendMessage(
//         chatRoomId: chatRoomId,
//         senderId: currentUser.uid,
//         senderName: brandName,
//         receiverId: application.influencerId,
//         receiverName: application.influencerName,
//         message: acceptanceMessage,
//         messageType: 'acceptance',
//         campaignId: application.campaignId,
//       );

//       // Update application status to accepted
//       await _firestore.collection('applications').doc(application.id).update({
//         'status': 'accepted',
//         'respondedAt': DateTime.now(),
//         'chatRoomId': chatRoomId,
//       });

//       _isSending = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       print('Error sending acceptance message: $e');
//       _isSending = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Create or update chat room
//   Future<void> _createOrUpdateChatRoom({
//     required String chatRoomId,
//     required String brandId,
//     required String influencerId,
//     required String brandName,
//     required String influencerName,
//     required String campaignTitle,
//   }) async {
//     final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

//     await chatRoomRef.set({
//       'id': chatRoomId,
//       'brandId': brandId,
//       'influencerId': influencerId,
//       'brandName': brandName,
//       'influencerName': influencerName,
//       'campaignTitle': campaignTitle,
//       'createdAt': FieldValue.serverTimestamp(),
//       'lastMessage': '',
//       'lastMessageTime': FieldValue.serverTimestamp(),
//       'participants': [brandId, influencerId],
//       'isActive': true,
//     }, SetOptions(merge: true));
//   }

//   // Send message
//   Future<void> _sendMessage({
//     required String chatRoomId,
//     required String senderId,
//     required String senderName,
//     required String receiverId,
//     required String receiverName,
//     required String message,
//     required String messageType,
//     String? campaignId,
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
//       'campaignId': campaignId,
//     });

//     // Update chat room with last message
//     await _firestore.collection('chatRooms').doc(chatRoomId).update({
//       'lastMessage':
//           message.length > 50 ? '${message.substring(0, 50)}...' : message,
//       'lastMessageTime': FieldValue.serverTimestamp(),
//     });
//   }

//   // Send regular message
//   Future<bool> sendMessage({
//     required String chatRoomId,
//     required String receiverId,
//     required String receiverName,
//     required String message,
//   }) async {
//     try {
//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return false;

//       // Get brand name
//       final brandDoc =
//           await _firestore.collection('brands').doc(currentUser.uid).get();

//       final brandName = brandDoc.data()?['brandName'] ?? 'Brand';

//       await _sendMessage(
//         chatRoomId: chatRoomId,
//         senderId: currentUser.uid,
//         senderName: brandName,
//         receiverId: receiverId,
//         receiverName: receiverName,
//         message: message,
//         messageType: 'text',
//       );

//       return true;
//     } catch (e) {
//       print('Error sending message: $e');
//       return false;
//     }
//   }

//   // Fetch chat rooms for current brand
//   Future<void> fetchChatRooms() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final currentUser = _auth.currentUser;
//       if (currentUser == null) return;

//       final snapshot =
//           await _firestore
//               .collection('chatRooms')
//               .where('brandId', isEqualTo: currentUser.uid)
//               .orderBy('lastMessageTime', descending: true)
//               .get();

//       _chatRooms =
//           snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList();

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       print('Error fetching chat rooms: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Fetch messages for a specific chat room
//   Stream<List<Message>> getMessagesStream(String chatRoomId) {
//     return _firestore
//         .collection('chatRooms')
//         .doc(chatRoomId)
//         .collection('messages')
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map(
//           (snapshot) =>
//               snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList(),
//         );
//   }

//   // Generate chat room ID
//   String _generateChatRoomId(String brandId, String influencerId) {
//     final ids = [brandId, influencerId]..sort();
//     return '${ids[0]}_${ids[1]}';
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
//     } catch (e) {
//       print('Error marking messages as read: $e');
//     }
//   }
// }

// // Models
// class ChatRoom {
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

//   ChatRoom({
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
//   });

//   factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return ChatRoom(
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
//     );
//   }
// }

// class Message {
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

//   Message({
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

//   factory Message.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Message(
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
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _isSending = false;
  List<ChatRoom> _chatRooms = [];
  List<Message> _messages = [];

  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  List<ChatRoom> get chatRooms => _chatRooms;
  List<Message> get messages => _messages;

  // Send acceptance message to influencer
  Future<bool> sendAcceptanceMessage({
    required ApplicationModel application,
    required String brandName,
    required String campaignTitle,
  }) async {
    try {
      _isSending = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Create or get existing chat room
      final chatRoomId = _generateChatRoomId(
        currentUser.uid,
        application.influencerId,
      );

      // Acceptance message template
      final acceptanceMessage = """
🎉 Congratulations! Your Application has been ACCEPTED! 🎉

Hi ${application.influencerName}!

We're thrilled to inform you that your profile is a perfect match for our "${campaignTitle}" campaign. We would love to collaborate with you!

Your content style and audience engagement align perfectly with our brand vision. We believe this partnership will create amazing results! ✨

📅 Next Steps:
We'd like to schedule a meeting to discuss:
• Campaign details and requirements
• Content deliverables and timelines  
• Compensation and collaboration terms
• Creative direction and brand guidelines

When would you be available for a meeting? Please share your preferred:
• Date options (next 7-14 days)
• Time slots that work best for you
• Preferred meeting format (video call/phone/in-person)

We're excited to work with you and create something extraordinary together! 🚀

Best regards,
${brandName} Team

---
Campaign: ${campaignTitle}
""";

      // Create chat room if it doesn't exist
      await _createOrUpdateChatRoom(
        chatRoomId: chatRoomId,
        brandId: currentUser.uid,
        influencerId: application.influencerId,
        brandName: brandName,
        influencerName: application.influencerName,
        campaignTitle: campaignTitle,
      );

      // Send the acceptance message
      await _sendMessage(
        chatRoomId: chatRoomId,
        senderId: currentUser.uid,
        senderName: brandName,
        receiverId: application.influencerId,
        receiverName: application.influencerName,
        message: acceptanceMessage,
        messageType: 'acceptance',
        campaignId: application.campaignId,
      );

      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error sending acceptance message: $e');
      _isSending = false;
      notifyListeners();
      return false;
    }
  }

  // Create or update chat room
  Future<void> _createOrUpdateChatRoom({
    required String chatRoomId,
    required String brandId,
    required String influencerId,
    required String brandName,
    required String influencerName,
    required String campaignTitle,
  }) async {
    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);

    await chatRoomRef.set({
      'id': chatRoomId,
      'brandId': brandId,
      'influencerId': influencerId,
      'brandName': brandName,
      'influencerName': influencerName,
      'campaignTitle': campaignTitle,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': 'Application accepted! Meeting requested.',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'participants': [brandId, influencerId],
      'isActive': true,
      'unreadCount': {'brand': 0, 'influencer': 1},
    }, SetOptions(merge: true));
  }

  // Send message
  Future<void> _sendMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String message,
    required String messageType,
    String? campaignId,
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
      'campaignId': campaignId,
    });

    // Update chat room with last message
    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage':
          message.length > 50 ? '${message.substring(0, 50)}...' : message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Send regular message
  Future<bool> sendMessage({
    required String chatRoomId,
    required String receiverId,
    required String receiverName,
    required String message,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get brand name
      final brandDoc =
          await _firestore.collection('brands').doc(currentUser.uid).get();
      final brandName = brandDoc.data()?['brandName'] ?? 'Brand';

      await _sendMessage(
        chatRoomId: chatRoomId,
        senderId: currentUser.uid,
        senderName: brandName,
        receiverId: receiverId,
        receiverName: receiverName,
        message: message,
        messageType: 'text',
      );

      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  // Fetch chat rooms for current brand (simplified to avoid index issues)
  Future<void> fetchChatRooms() async {
    try {
      _isLoading = true;
      notifyListeners();

      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Simple query without ordering by lastMessageTime to avoid index requirement
      final snapshot =
          await _firestore
              .collection('chatRooms')
              .where('brandId', isEqualTo: currentUser.uid)
              .get();

      List<ChatRoom> chatRooms =
          snapshot.docs.map((doc) => ChatRoom.fromFirestore(doc)).toList();

      // Sort in Dart instead of Firestore
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

  // Fetch messages for a specific chat room
  Stream<List<Message>> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList(),
        );
  }

  // Generate chat room ID
  String _generateChatRoomId(String brandId, String influencerId) {
    final ids = [brandId, influencerId]..sort();
    return '${ids[0]}_${ids[1]}';
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
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }
}

// Models
class ChatRoom {
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

  ChatRoom({
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
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoom(
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
    );
  }
}

class Message {
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

  Message({
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

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
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
