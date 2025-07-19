import 'dart:io';

import 'package:creatorcrew/Brand/Authentication/providers/CloudinaryProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/InfluencerProfile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InfluencerOnboardingProvider with ChangeNotifier {
  final CloudinaryProvider _cloudinaryProvider = CloudinaryProvider();

  // Basic Info
  String _fullName = '';
  String _username = '';
  String _email = '';
  String _phoneNumber = '';
  String? _gender;
  DateTime? _dateOfBirth;
  String _city = '';
  String _country = '';

  // Profile Setup
  File? _profileImage;
  String? _profileImageUrl;
  String _bio = '';
  List<String> _selectedCategories = [];
  List<String> _selectedLanguages = [];

  // Social Media Accounts
  List<SocialMediaAccount> _socialMediaAccounts = [];

  // Performance Metrics
  PerformanceMetrics? _performanceMetrics;

  // Professional Info
  ProfessionalInfo? _professionalInfo;

  // Additional Info
  AdditionalInfo? _additionalInfo;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get fullName => _fullName;
  String get username => _username;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String? get gender => _gender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String get city => _city;
  String get country => _country;
  File? get profileImage => _profileImage;
  String? get profileImageUrl => _profileImageUrl;
  String get bio => _bio;
  List<String> get selectedCategories => _selectedCategories;
  List<String> get selectedLanguages => _selectedLanguages;
  List<SocialMediaAccount> get socialMediaAccounts => _socialMediaAccounts;
  PerformanceMetrics? get performanceMetrics => _performanceMetrics;
  ProfessionalInfo? get professionalInfo => _professionalInfo;
  AdditionalInfo? get additionalInfo => _additionalInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Categories and Languages options
  final List<String> availableCategories = [
    'Fashion',
    'Tech',
    'Fitness',
    'Food',
    'Travel',
    'Comedy',
    'Beauty',
    'Lifestyle',
    'Gaming',
    'Music',
    'Art',
    'Education',
    'Business',
    'Health',
    'Sports',
    'Entertainment',
    'Photography',
    'DIY',
  ];

  final List<String> availableLanguages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Tamil',
    'Telugu',
    'Bengali',
    'Marathi',
    'Gujarati',
    'Punjabi',
  ];

  final List<String> socialMediaPlatforms = [
    'Instagram',
    'YouTube',
    'TikTok',
    'Twitter/X',
    'Snapchat',
    'LinkedIn',
    'Facebook',
    'Pinterest',
    'Twitch',
    'Other',
  ];

  // Setters for Basic Info
  void setFullName(String name) {
    _fullName = name;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void setGender(String? gender) {
    _gender = gender;
    notifyListeners();
  }

  void setDateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  void setCity(String city) {
    _city = city;
    notifyListeners();
  }

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }

  // Profile Setup Methods
  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        _profileImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> uploadProfileImage() async {
    if (_profileImage == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await _cloudinaryProvider.uploadImage(
        _profileImage!,
        folder: 'influencer_profiles',
      );

      if (imageUrl != null) {
        _profileImageUrl = imageUrl;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to upload image';
      }
    } catch (e) {
      _errorMessage = 'Error uploading image: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleLanguage(String language) {
    if (_selectedLanguages.contains(language)) {
      _selectedLanguages.remove(language);
    } else {
      _selectedLanguages.add(language);
    }
    notifyListeners();
  }

  // Social Media Methods
  void addSocialMediaAccount(SocialMediaAccount account) {
    _socialMediaAccounts.add(account);
    notifyListeners();
  }

  void removeSocialMediaAccount(int index) {
    if (index >= 0 && index < _socialMediaAccounts.length) {
      _socialMediaAccounts.removeAt(index);
      notifyListeners();
    }
  }

  void updateSocialMediaAccount(int index, SocialMediaAccount account) {
    if (index >= 0 && index < _socialMediaAccounts.length) {
      _socialMediaAccounts[index] = account;
      notifyListeners();
    }
  }

  // Performance Metrics
  void setPerformanceMetrics(PerformanceMetrics metrics) {
    _performanceMetrics = metrics;
    notifyListeners();
  }

  // Professional Info
  void setProfessionalInfo(ProfessionalInfo info) {
    _professionalInfo = info;
    notifyListeners();
  }

  // Additional Info
  void setAdditionalInfo(AdditionalInfo info) {
    _additionalInfo = info;
    notifyListeners();
  }

  // Validation Methods
  bool validateBasicInfo() {
    return _fullName.isNotEmpty &&
        _username.isNotEmpty &&
        _email.isNotEmpty &&
        _phoneNumber.isNotEmpty;
  }

  bool validateProfileSetup() {
    return _bio.isNotEmpty && _selectedCategories.isNotEmpty;
  }

  bool validateSocialMedia() {
    return _socialMediaAccounts.isNotEmpty;
  }

  // Complete Profile Creation
  InfluencerProfile createProfile() {
    return InfluencerProfile(
      fullName: _fullName,
      username: _username,
      email: _email,
      phoneNumber: _phoneNumber,
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      city: _city,
      country: _country,
      profilePictureUrl: _profileImageUrl,
      bio: _bio,
      categories: _selectedCategories,
      languagesSpoken: _selectedLanguages,
      socialMediaAccounts: _socialMediaAccounts,
      performanceMetrics: _performanceMetrics,
      professionalInfo: _professionalInfo,
      additionalInfo: _additionalInfo,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Save Profile (implement your backend logic here)
  Future<bool> saveProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Upload profile image if exists
      if (_profileImage != null && _profileImageUrl == null) {
        await uploadProfileImage();
      }

      final profile = createProfile();

      // TODO: Implement your backend API call here
      // Example:
      // final response = await apiService.createInfluencerProfile(profile);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save profile: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset all data
  void reset() {
    _fullName = '';
    _username = '';
    _email = '';
    _phoneNumber = '';
    _gender = null;
    _dateOfBirth = null;
    _city = '';
    _country = '';
    _profileImage = null;
    _profileImageUrl = null;
    _bio = '';
    _selectedCategories.clear();
    _selectedLanguages.clear();
    _socialMediaAccounts.clear();
    _performanceMetrics = null;
    _professionalInfo = null;
    _additionalInfo = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
