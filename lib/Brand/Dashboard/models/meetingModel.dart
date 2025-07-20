// import 'package:cloud_firestore/cloud_firestore.dart';

// class Meeting {
//   final String id;
//   final String chatRoomId;
//   final String brandId;
//   final String influencerId;
//   final String brandName;
//   final String influencerName;
//   final String campaignTitle;
//   final DateTime scheduledDateTime;
//   final int durationMinutes;
//   final MeetingType type;
//   final MeetingStatus status;
//   final String? meetingLink;
//   final String? meetingPassword;
//   final String? agenda;
//   final String? notes;
//   final DateTime createdAt;
//   final DateTime? updatedAt;
//   final List<String> attendees;
//   final Map<String, dynamic>? meetingSettings;

//   Meeting({
//     required this.id,
//     required this.chatRoomId,
//     required this.brandId,
//     required this.influencerId,
//     required this.brandName,
//     required this.influencerName,
//     required this.campaignTitle,
//     required this.scheduledDateTime,
//     required this.durationMinutes,
//     required this.type,
//     required this.status,
//     this.meetingLink,
//     this.meetingPassword,
//     this.agenda,
//     this.notes,
//     required this.createdAt,
//     this.updatedAt,
//     required this.attendees,
//     this.meetingSettings,
//   });

//   factory Meeting.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Meeting(
//       id: doc.id,
//       chatRoomId: data['chatRoomId'] ?? '',
//       brandId: data['brandId'] ?? '',
//       influencerId: data['influencerId'] ?? '',
//       brandName: data['brandName'] ?? '',
//       influencerName: data['influencerName'] ?? '',
//       campaignTitle: data['campaignTitle'] ?? '',
//       scheduledDateTime: (data['scheduledDateTime'] as Timestamp).toDate(),
//       durationMinutes: data['durationMinutes'] ?? 30,
//       type: MeetingType.values.firstWhere(
//         (e) => e.toString() == 'MeetingType.${data['type']}',
//         orElse: () => MeetingType.video,
//       ),
//       status: MeetingStatus.values.firstWhere(
//         (e) => e.toString() == 'MeetingStatus.${data['status']}',
//         orElse: () => MeetingStatus.scheduled,
//       ),
//       meetingLink: data['meetingLink'],
//       meetingPassword: data['meetingPassword'],
//       agenda: data['agenda'],
//       notes: data['notes'],
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//       updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
//       attendees: List<String>.from(data['attendees'] ?? []),
//       meetingSettings: data['meetingSettings'],
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     return {
//       'chatRoomId': chatRoomId,
//       'brandId': brandId,
//       'influencerId': influencerId,
//       'brandName': brandName,
//       'influencerName': influencerName,
//       'campaignTitle': campaignTitle,
//       'scheduledDateTime': Timestamp.fromDate(scheduledDateTime),
//       'durationMinutes': durationMinutes,
//       'type': type.toString().split('.').last,
//       'status': status.toString().split('.').last,
//       'meetingLink': meetingLink,
//       'meetingPassword': meetingPassword,
//       'agenda': agenda,
//       'notes': notes,
//       'createdAt': Timestamp.fromDate(createdAt),
//       'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
//       'attendees': attendees,
//       'meetingSettings': meetingSettings,
//     };
//   }
// }

// enum MeetingType { video, audio, inPerson, phone }

// enum MeetingStatus { scheduled, ongoing, completed, cancelled, rescheduled }

// class TimeSlot {
//   final DateTime startTime;
//   final DateTime endTime;
//   final bool isAvailable;

//   TimeSlot({
//     required this.startTime,
//     required this.endTime,
//     this.isAvailable = true,
//   });
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Meeting {
  final String id;
  final String chatRoomId;
  final String brandId;
  final String influencerId;
  final String brandName;
  final String influencerName;
  final String campaignTitle;
  final DateTime scheduledDateTime;
  final int durationMinutes;
  final MeetingType type;
  final MeetingStatus status;
  final String? meetingLink;
  final String? meetingPassword;
  final String? agenda;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> attendees;
  final Map<String, dynamic>? meetingSettings;

  Meeting({
    required this.id,
    required this.chatRoomId,
    required this.brandId,
    required this.influencerId,
    required this.brandName,
    required this.influencerName,
    required this.campaignTitle,
    required this.scheduledDateTime,
    required this.durationMinutes,
    required this.type,
    required this.status,
    this.meetingLink,
    this.meetingPassword,
    this.agenda,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.attendees,
    this.meetingSettings,
  });

  factory Meeting.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meeting(
      id: doc.id,
      chatRoomId: data['chatRoomId'] ?? '',
      brandId: data['brandId'] ?? '',
      influencerId: data['influencerId'] ?? '',
      brandName: data['brandName'] ?? '',
      influencerName: data['influencerName'] ?? '',
      campaignTitle: data['campaignTitle'] ?? '',
      scheduledDateTime: (data['scheduledDateTime'] as Timestamp).toDate(),
      durationMinutes: data['durationMinutes'] ?? 30,
      type: MeetingType.values.firstWhere(
        (e) => e.toString() == 'MeetingType.${data['type']}',
        orElse: () => MeetingType.video,
      ),
      status: MeetingStatus.values.firstWhere(
        (e) => e.toString() == 'MeetingStatus.${data['status']}',
        orElse: () => MeetingStatus.scheduled,
      ),
      meetingLink: data['meetingLink'],
      meetingPassword: data['meetingPassword'],
      agenda: data['agenda'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      attendees: List<String>.from(data['attendees'] ?? []),
      meetingSettings: data['meetingSettings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'chatRoomId': chatRoomId,
      'brandId': brandId,
      'influencerId': influencerId,
      'brandName': brandName,
      'influencerName': influencerName,
      'campaignTitle': campaignTitle,
      'scheduledDateTime': Timestamp.fromDate(scheduledDateTime),
      'durationMinutes': durationMinutes,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'meetingLink': meetingLink,
      'meetingPassword': meetingPassword,
      'agenda': agenda,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'attendees': attendees,
      'meetingSettings': meetingSettings,
    };
  }
}

enum MeetingType { video, audio, inPerson, phone }

enum MeetingStatus { scheduled, ongoing, completed, cancelled, rescheduled }

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });
}
