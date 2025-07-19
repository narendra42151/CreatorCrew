import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Authentication/providers/CloudinaryProvider.dart';
import 'package:creatorcrew/Brand/Dashboard/Models/CampaignModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CampaignProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudinaryProvider _cloudinaryProvider = CloudinaryProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Upload a campaign attachment to Cloudinary
  Future<String?> uploadAttachment(PlatformFile file) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      // Create a File object from PlatformFile
      File fileToUpload = File(file.path!);

      return await _cloudinaryProvider.uploadImage(
        fileToUpload,
        folder: 'creator_crew/campaign_attachments/$userId',
      );
    } catch (e) {
      print('Error uploading attachment: $e');
      return null;
    }
  }

  // Upload multiple attachments and return list of URLs
  Future<List<String>> uploadAttachments(List<PlatformFile> files) async {
    List<String> urls = [];

    for (var file in files) {
      String? url = await uploadAttachment(file);
      if (url != null) {
        urls.add(url);
      }
    }

    return urls;
  }

  // Create a new campaign in Firestore
  Future<bool> createCampaign(
    String title,
    String description,
    String category,
    List<String> platforms,
    DateTime startDate,
    DateTime endDate,
    TimeOfDay? preferredTime,
    double followerRangeStart,
    double followerRangeEnd,
    String location,
    String language,
    String? engagementRate,
    bool hasImagePost,
    bool hasVideo,
    bool hasStory,
    bool hasReelShort,
    String budgetPerInfluencer,
    String totalBudget,
    String paymentMethod,
    List<PlatformFile> attachments,
  ) async {
    setLoading(true);

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return false;
      }

      // Upload attachments
      List<String> attachmentUrls = await uploadAttachments(attachments);

      // Create campaign model
      final campaign = CampaignModel(
        brandId: userId,
        title: title,
        description: description,
        category: category,
        platforms: platforms,
        startDate: startDate,
        endDate: endDate,
        preferredTime:
            preferredTime != null
                ? '${preferredTime.hour}:${preferredTime.minute.toString().padLeft(2, '0')}'
                : null,
        followerRangeStart: followerRangeStart,
        followerRangeEnd: followerRangeEnd,
        location: location,
        language: language,
        engagementRate:
            engagementRate != null && engagementRate.isNotEmpty
                ? double.tryParse(engagementRate)
                : null,
        hasImagePost: hasImagePost,
        hasVideo: hasVideo,
        hasStory: hasStory,
        hasReelShort: hasReelShort,
        budgetPerInfluencer: double.parse(budgetPerInfluencer),
        totalBudget: double.parse(totalBudget),
        paymentMethod: paymentMethod,
        attachments: attachmentUrls,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      DocumentReference docRef = await _firestore
          .collection('campaigns')
          .add(campaign.toJson());

      // Update the document with its ID
      await docRef.update({'id': docRef.id});

      setLoading(false);
      return true;
    } catch (e) {
      print('Error creating campaign: $e');
      setLoading(false);
      return false;
    }
  }

  // Fetch all campaigns for current brand
  // ...existing code...

  // Fetch all campaigns for current brand
  Future<List<CampaignModel>> fetchCampaigns() async {
    setLoading(true);
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        setLoading(false);
        return [];
      }

      // Modified query - fetch by brandId only and sort in Dart
      final snapshot =
          await _firestore
              .collection('campaigns')
              .where('brandId', isEqualTo: userId)
              .get();

      List<CampaignModel> campaigns =
          snapshot.docs
              .map((doc) => CampaignModel.fromJson(doc.data()))
              .toList();

      // Sort by createdAt in Dart instead of Firestore
      campaigns.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setLoading(false);
      return campaigns;
    } catch (e) {
      print('Error fetching campaigns: $e');
      setLoading(false);
      return [];
    }
  }

  // ...existing code...
}
