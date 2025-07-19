// filepath: c:\Users\naren\OneDrive\Desktop\CreatorCrew\creatorcrew\lib\infliencers\PrifleCreation\Models\InfluencerProfile.dart
class InfluencerProfile {
  final String fullName;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? city;
  final String? country;
  final String? profilePictureUrl;
  final String? bio;
  final List<String> categories;
  final List<String> languagesSpoken;
  final List<SocialMediaAccount> socialMediaAccounts;
  final PerformanceMetrics? performanceMetrics;
  final ProfessionalInfo? professionalInfo;
  final AdditionalInfo? additionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  InfluencerProfile({
    required this.fullName,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.country,
    this.profilePictureUrl,
    this.bio,
    this.categories = const [],
    this.languagesSpoken = const [],
    this.socialMediaAccounts = const [],
    this.performanceMetrics,
    this.professionalInfo,
    this.additionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  // ...existing code...

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'city': city,
      'country': country,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'categories': categories,
      'languagesSpoken': languagesSpoken,
      'socialMediaAccounts':
          socialMediaAccounts.map((e) => e.toJson()).toList(),
      'performanceMetrics': performanceMetrics?.toJson(),
      'professionalInfo': professionalInfo?.toJson(),
      'additionalInfo': additionalInfo?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory InfluencerProfile.fromJson(Map<String, dynamic> json) {
    return InfluencerProfile(
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'],
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'] ?? '',
      categories: List<String>.from(json['categories'] ?? []),
      languagesSpoken: List<String>.from(json['languagesSpoken'] ?? []),
      socialMediaAccounts:
          (json['socialMediaAccounts'] as List<dynamic>? ?? [])
              .map((e) => SocialMediaAccount.fromJson(e))
              .toList(),
      performanceMetrics:
          json['performanceMetrics'] != null
              ? PerformanceMetrics.fromJson(json['performanceMetrics'])
              : null,
      professionalInfo:
          json['professionalInfo'] != null
              ? ProfessionalInfo.fromJson(json['professionalInfo'])
              : null,
      additionalInfo:
          json['additionalInfo'] != null
              ? AdditionalInfo.fromJson(json['additionalInfo'])
              : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SocialMediaAccount {
  final String platform;
  final String username;
  final int followerCount;
  final double? engagementRate;
  final int? avgViews;
  final String? channelLink;
  final String? profileUrl;

  SocialMediaAccount({
    required this.platform,
    required this.username,
    required this.followerCount,
    this.engagementRate,
    this.avgViews,
    this.channelLink,
    this.profileUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'username': username,
      'followerCount': followerCount,
      'engagementRate': engagementRate,
      'avgViews': avgViews,
      'channelLink': channelLink,
      'profileUrl': profileUrl,
    };
  }

  factory SocialMediaAccount.fromJson(Map<String, dynamic> json) {
    return SocialMediaAccount(
      platform: json['platform'] ?? '',
      username: json['username'] ?? '',
      followerCount: json['followerCount'] ?? 0,
      engagementRate: json['engagementRate']?.toDouble(),
      avgViews: json['avgViews'],
      channelLink: json['channelLink'],
      profileUrl: json['profileUrl'],
    );
  }
}

class PerformanceMetrics {
  final int totalFollowers;
  final double averageEngagementRate;
  final int averageViews;
  final List<String> pastCampaigns;

  PerformanceMetrics({
    required this.totalFollowers,
    required this.averageEngagementRate,
    required this.averageViews,
    required this.pastCampaigns,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalFollowers': totalFollowers,
      'averageEngagementRate': averageEngagementRate,
      'averageViews': averageViews,
      'pastCampaigns': pastCampaigns,
    };
  }

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      totalFollowers: json['totalFollowers'] ?? 0,
      averageEngagementRate: json['averageEngagementRate']?.toDouble() ?? 0.0,
      averageViews: json['averageViews'] ?? 0,
      pastCampaigns: List<String>.from(json['pastCampaigns'] ?? []),
    );
  }
}

class ProfessionalInfo {
  final RateCard? rateCard;
  final Availability? availability;
  final List<String> pastCollaborationBrands;

  ProfessionalInfo({
    this.rateCard,
    this.availability,
    this.pastCollaborationBrands = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'rateCard': rateCard?.toJson(),
      'availability': availability?.toJson(),
      'pastCollaborationBrands': pastCollaborationBrands,
    };
  }

  factory ProfessionalInfo.fromJson(Map<String, dynamic> json) {
    return ProfessionalInfo(
      rateCard:
          json['rateCard'] != null ? RateCard.fromJson(json['rateCard']) : null,
      availability:
          json['availability'] != null
              ? Availability.fromJson(json['availability'])
              : null,
      pastCollaborationBrands: List<String>.from(
        json['pastCollaborationBrands'] ?? [],
      ),
    );
  }
}

class RateCard {
  final double? postRate;
  final double? storyRate;
  final double? videoRate;
  final double? reelRate;

  RateCard({this.postRate, this.storyRate, this.videoRate, this.reelRate});

  Map<String, dynamic> toJson() {
    return {
      'postRate': postRate,
      'storyRate': storyRate,
      'videoRate': videoRate,
      'reelRate': reelRate,
    };
  }

  factory RateCard.fromJson(Map<String, dynamic> json) {
    return RateCard(
      postRate: json['postRate']?.toDouble(),
      storyRate: json['storyRate']?.toDouble(),
      videoRate: json['videoRate']?.toDouble(),
      reelRate: json['reelRate']?.toDouble(),
    );
  }
}

class Availability {
  final bool weekdays;
  final bool weekends;
  final List<DateTime> specificDates;

  Availability({
    required this.weekdays,
    required this.weekends,
    this.specificDates = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'weekdays': weekdays,
      'weekends': weekends,
      'specificDates': specificDates.map((e) => e.toIso8601String()).toList(),
    };
  }

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      weekdays: json['weekdays'] ?? false,
      weekends: json['weekends'] ?? false,
      specificDates:
          (json['specificDates'] as List?)
              ?.map((e) => DateTime.parse(e))
              .toList() ??
          [],
    );
  }
}

class AdditionalInfo {
  final String? gstNumber;
  final String? panNumber;
  final String? paymentMethod;
  final String? referralCode;

  AdditionalInfo({
    this.gstNumber,
    this.panNumber,
    this.paymentMethod,
    this.referralCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'paymentMethod': paymentMethod,
      'referralCode': referralCode,
    };
  }

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      gstNumber: json['gstNumber'],
      panNumber: json['panNumber'],
      paymentMethod: json['paymentMethod'],
      referralCode: json['referralCode'],
    );
  }
}
