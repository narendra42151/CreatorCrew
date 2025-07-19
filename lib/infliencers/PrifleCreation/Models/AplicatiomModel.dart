import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String? id;
  final String campaignId;
  final String influencerId;
  final String brandId;
  final String campaignTitle;
  final String influencerName;
  final String influencerEmail;
  final String status; // 'pending', 'accepted', 'rejected'
  final String? message; // Optional message from influencer
  final DateTime appliedAt;
  final DateTime? respondedAt;

  ApplicationModel({
    this.id,
    required this.campaignId,
    required this.influencerId,
    required this.brandId,
    required this.campaignTitle,
    required this.influencerName,
    required this.influencerEmail,
    required this.status,
    this.message,
    required this.appliedAt,
    this.respondedAt,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      campaignId: json['campaignId'],
      influencerId: json['influencerId'],
      brandId: json['brandId'],
      campaignTitle: json['campaignTitle'],
      influencerName: json['influencerName'],
      influencerEmail: json['influencerEmail'],
      status: json['status'],
      message: json['message'],
      appliedAt: (json['appliedAt'] as Timestamp).toDate(),
      respondedAt:
          json['respondedAt'] != null
              ? (json['respondedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'campaignId': campaignId,
      'influencerId': influencerId,
      'brandId': brandId,
      'campaignTitle': campaignTitle,
      'influencerName': influencerName,
      'influencerEmail': influencerEmail,
      'status': status,
      'message': message,
      'appliedAt': appliedAt,
      'respondedAt': respondedAt,
    };
  }
}
