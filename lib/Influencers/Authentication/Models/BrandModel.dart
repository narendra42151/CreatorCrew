class BrandModel {
  final String? id;
  final String brandName;
  final String contactPerson;
  final String contactNumber;
  final String? website;
  final String email;

  // Company Profile
  final String? logoUrl;
  final String description;
  final String industryType;
  final LocationModel location;
  final String companySize;

  // Social Media
  final SocialMediaModel socialMedia;

  // Marketing Preferences
  final MarketingPreferencesModel marketingPreferences;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  BrandModel({
    this.id,
    required this.brandName,
    required this.contactPerson,
    required this.contactNumber,
    this.website,
    required this.email,
    this.logoUrl,
    required this.description,
    required this.industryType,
    required this.location,
    required this.companySize,
    required this.socialMedia,
    required this.marketingPreferences,
    this.createdAt,
    this.updatedAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      brandName: json['brandName'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      website: json['website'],
      email: json['email'] ?? '',
      logoUrl: json['logoUrl'],
      description: json['description'] ?? '',
      industryType: json['industryType'] ?? '',
      location: LocationModel.fromJson(json['location'] ?? {}),
      companySize: json['companySize'] ?? '',
      socialMedia: SocialMediaModel.fromJson(json['socialMedia'] ?? {}),
      marketingPreferences: MarketingPreferencesModel.fromJson(
        json['marketingPreferences'] ?? {},
      ),
      createdAt:
          json['createdAt'] != null ? (json['createdAt'] as DateTime) : null,
      updatedAt:
          json['updatedAt'] != null ? (json['updatedAt'] as DateTime) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brandName': brandName,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'website': website,
      'email': email,
      'logoUrl': logoUrl,
      'description': description,
      'industryType': industryType,
      'location': location.toJson(),
      'companySize': companySize,
      'socialMedia': socialMedia.toJson(),
      'marketingPreferences': marketingPreferences.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class LocationModel {
  final String? country;
  final String? city;
  final String? address;

  LocationModel({this.country, this.city, this.address});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      country: json['country'],
      city: json['city'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'country': country, 'city': city, 'address': address};
  }
}

class SocialMediaModel {
  final String? instagram;
  final String? linkedin;
  final String? twitter;
  final String? youtube;
  final String? facebook;

  SocialMediaModel({
    this.instagram,
    this.linkedin,
    this.twitter,
    this.youtube,
    this.facebook,
  });

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      twitter: json['twitter'],
      youtube: json['youtube'],
      facebook: json['facebook'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'linkedin': linkedin,
      'twitter': twitter,
      'youtube': youtube,
      'facebook': facebook,
    };
  }
}

class MarketingPreferencesModel {
  final List<String> influencerCategories;
  final List<String> audienceAgeRanges;
  final List<String> targetLocations;
  final String budgetRange;
  final List<String> campaignGoals;

  MarketingPreferencesModel({
    required this.influencerCategories,
    required this.audienceAgeRanges,
    required this.targetLocations,
    required this.budgetRange,
    required this.campaignGoals,
  });

  factory MarketingPreferencesModel.fromJson(Map<String, dynamic> json) {
    return MarketingPreferencesModel(
      influencerCategories: List<String>.from(
        json['influencerCategories'] ?? [],
      ),
      audienceAgeRanges: List<String>.from(json['audienceAgeRanges'] ?? []),
      targetLocations: List<String>.from(json['targetLocations'] ?? []),
      budgetRange: json['budgetRange'] ?? '',
      campaignGoals: List<String>.from(json['campaignGoals'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'influencerCategories': influencerCategories,
      'audienceAgeRanges': audienceAgeRanges,
      'targetLocations': targetLocations,
      'budgetRange': budgetRange,
      'campaignGoals': campaignGoals,
    };
  }
}
