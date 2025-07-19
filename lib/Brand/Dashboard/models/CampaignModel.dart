import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignModel {
  final String? id;
  final String brandId;
  final String title;
  final String description;
  final String category;
  final List<String> platforms;
  final DateTime startDate;
  final DateTime endDate;
  final String? preferredTime;
  final double followerRangeStart;
  final double followerRangeEnd;
  final String location;
  final String language;
  final double? engagementRate;
  final bool hasImagePost;
  final bool hasVideo;
  final bool hasStory;
  final bool hasReelShort;
  final double budgetPerInfluencer;
  final double totalBudget;
  final String paymentMethod;
  final List<String> attachments;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CampaignModel({
    this.id,
    required this.brandId,
    required this.title,
    required this.description,
    required this.category,
    required this.platforms,
    required this.startDate,
    required this.endDate,
    this.preferredTime,
    required this.followerRangeStart,
    required this.followerRangeEnd,
    required this.location,
    required this.language,
    this.engagementRate,
    required this.hasImagePost,
    required this.hasVideo,
    required this.hasStory,
    required this.hasReelShort,
    required this.budgetPerInfluencer,
    required this.totalBudget,
    required this.paymentMethod,
    required this.attachments,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      brandId: json['brandId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      platforms: List<String>.from(json['platforms']),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      preferredTime: json['preferredTime'],
      followerRangeStart: json['followerRangeStart'],
      followerRangeEnd: json['followerRangeEnd'],
      location: json['location'],
      language: json['language'],
      engagementRate: json['engagementRate'],
      hasImagePost: json['hasImagePost'],
      hasVideo: json['hasVideo'],
      hasStory: json['hasStory'],
      hasReelShort: json['hasReelShort'],
      budgetPerInfluencer: json['budgetPerInfluencer'],
      totalBudget: json['totalBudget'],
      paymentMethod: json['paymentMethod'],
      attachments: List<String>.from(json['attachments']),
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandId': brandId,
      'title': title,
      'description': description,
      'category': category,
      'platforms': platforms,
      'startDate': startDate,
      'endDate': endDate,
      'preferredTime': preferredTime,
      'followerRangeStart': followerRangeStart,
      'followerRangeEnd': followerRangeEnd,
      'location': location,
      'language': language,
      'engagementRate': engagementRate,
      'hasImagePost': hasImagePost,
      'hasVideo': hasVideo,
      'hasStory': hasStory,
      'hasReelShort': hasReelShort,
      'budgetPerInfluencer': budgetPerInfluencer,
      'totalBudget': totalBudget,
      'paymentMethod': paymentMethod,
      'attachments': attachments,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
