import 'package:shared_preferences/shared_preferences.dart';

class InfluencerSessionManager {
  static const String _keyInfluencerName = 'influencer_name';
  static const String _keyInfluencerUsername = 'influencer_username';
  static const String _keyInfluencerProfileUrl = 'influencer_profile_url';
  static const String _keyIsOnboarded = 'is_influencer_onboarded';

  // Save influencer data to SharedPreferences
  static Future<void> saveInfluencerData({
    required String fullName,
    required String username,
    String? profileUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyInfluencerName, fullName);
    await prefs.setString(_keyInfluencerUsername, username);
    if (profileUrl != null) {
      await prefs.setString(_keyInfluencerProfileUrl, profileUrl);
    }
    await prefs.setBool(_keyIsOnboarded, true);
  }

  // Get influencer name
  static Future<String?> getInfluencerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInfluencerName);
  }

  // Get influencer username
  static Future<String?> getInfluencerUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInfluencerUsername);
  }

  // Get influencer profile URL
  static Future<String?> getInfluencerProfileUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyInfluencerProfileUrl);
  }

  // Check if influencer is onboarded
  static Future<bool> isInfluencerOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsOnboarded) ?? false;
  }

  // Clear influencer data
  static Future<void> clearInfluencerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyInfluencerName);
    await prefs.remove(_keyInfluencerUsername);
    await prefs.remove(_keyInfluencerProfileUrl);
    await prefs.setBool(_keyIsOnboarded, false);
  }

  // Get all influencer data
  static Future<Map<String, dynamic>> getInfluencerData() async {
    return {
      'name': await getInfluencerName(),
      'username': await getInfluencerUsername(),
      'profileUrl': await getInfluencerProfileUrl(),
      'isOnboarded': await isInfluencerOnboarded(),
    };
  }
}
