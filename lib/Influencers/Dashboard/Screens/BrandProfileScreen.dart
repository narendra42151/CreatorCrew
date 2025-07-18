import 'package:creatorcrew/Influencers/Authentication/Models/BrandModel.dart';
import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandProfileScreen extends StatefulWidget {
  @override
  _BrandProfileScreenState createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends State<BrandProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch brand info when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandInfoProvider>(context, listen: false).fetchBrandInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BrandInfoProvider>(
        builder: (context, brandProvider, child) {
          if (brandProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
              ),
            );
          }

          final brandInfo = brandProvider.brandInfo;
          if (brandInfo == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No Brand Profile Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please complete your brand profile setup',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Header Card
                _buildHeaderCard(brandInfo),
                SizedBox(height: 20),

                // Basic Information Card
                _buildInfoCard('Basic Information', Icons.business, [
                  _buildInfoRow('Brand Name', brandInfo.brandName),
                  _buildInfoRow('Contact Person', brandInfo.contactPerson),
                  _buildInfoRow('Contact Number', brandInfo.contactNumber),
                  _buildInfoRow('Email', brandInfo.email),
                  if (brandInfo.website != null &&
                      brandInfo.website!.isNotEmpty)
                    _buildInfoRow('Website', brandInfo.website!),
                ]),
                SizedBox(height: 16),

                // Company Profile Card
                _buildInfoCard('Company Profile', Icons.apartment, [
                  _buildInfoRow('Description', brandInfo.description),
                  _buildInfoRow('Industry Type', brandInfo.industryType),
                  _buildInfoRow('Company Size', brandInfo.companySize),
                  if (brandInfo.location.country != null)
                    _buildInfoRow('Country', brandInfo.location.country!),
                  if (brandInfo.location.city != null)
                    _buildInfoRow('City', brandInfo.location.city!),
                  if (brandInfo.location.address != null)
                    _buildInfoRow('Address', brandInfo.location.address!),
                ]),
                SizedBox(height: 16),

                // Social Media Card
                if (_hasSocialMedia(brandInfo.socialMedia))
                  _buildSocialMediaCard(brandInfo.socialMedia),
                if (_hasSocialMedia(brandInfo.socialMedia))
                  SizedBox(height: 16),

                // Marketing Preferences Card
                _buildMarketingPreferencesCard(brandInfo.marketingPreferences),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(BrandModel brandInfo) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4CAF50).withOpacity(0.9),
            Color(0xFF2E7D32).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Brand Logo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child:
                brandInfo.logoUrl != null && brandInfo.logoUrl!.isNotEmpty
                    ? ClipOval(
                      child: Image.network(
                        brandInfo.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Icon(
                              Icons.business,
                              size: 40,
                              color: Color(0xFF4CAF50),
                            ),
                      ),
                    )
                    : Icon(Icons.business, size: 40, color: Color(0xFF4CAF50)),
          ),
          SizedBox(height: 16),

          // Brand Name
          Text(
            brandInfo.brandName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),

          // Industry Type
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              brandInfo.industryType,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Color(0xFF4CAF50), size: 24),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasSocialMedia(SocialMediaModel socialMedia) {
    return (socialMedia.instagram?.isNotEmpty ?? false) ||
        (socialMedia.linkedin?.isNotEmpty ?? false) ||
        (socialMedia.twitter?.isNotEmpty ?? false) ||
        (socialMedia.youtube?.isNotEmpty ?? false) ||
        (socialMedia.facebook?.isNotEmpty ?? false);
  }

  Widget _buildSocialMediaCard(SocialMediaModel socialMedia) {
    List<Widget> socialLinks = [];

    if (socialMedia.instagram?.isNotEmpty ?? false) {
      socialLinks.add(
        _buildSocialLink(
          'Instagram',
          socialMedia.instagram!,
          Icons.camera_alt,
          Color(0xFFE1306C),
        ),
      );
    }
    if (socialMedia.linkedin?.isNotEmpty ?? false) {
      socialLinks.add(
        _buildSocialLink(
          'LinkedIn',
          socialMedia.linkedin!,
          Icons.business_center,
          Color(0xFF0077B5),
        ),
      );
    }
    if (socialMedia.twitter?.isNotEmpty ?? false) {
      socialLinks.add(
        _buildSocialLink(
          'Twitter',
          socialMedia.twitter!,
          Icons.chat_bubble_outline,
          Color(0xFF1DA1F2),
        ),
      );
    }
    if (socialMedia.youtube?.isNotEmpty ?? false) {
      socialLinks.add(
        _buildSocialLink(
          'YouTube',
          socialMedia.youtube!,
          Icons.play_arrow,
          Color(0xFFFF0000),
        ),
      );
    }
    if (socialMedia.facebook?.isNotEmpty ?? false) {
      socialLinks.add(
        _buildSocialLink(
          'Facebook',
          socialMedia.facebook!,
          Icons.thumb_up,
          Color(0xFF1877F2),
        ),
      );
    }

    return _buildInfoCard('Social Media', Icons.share, socialLinks);
  }

  Widget _buildSocialLink(
    String platform,
    String url,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              url,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketingPreferencesCard(MarketingPreferencesModel preferences) {
    return _buildInfoCard('Marketing Preferences', Icons.campaign, [
      if (preferences.influencerCategories.isNotEmpty)
        _buildChipSection(
          'Preferred Influencer Categories',
          preferences.influencerCategories,
        ),
      if (preferences.audienceAgeRanges.isNotEmpty)
        _buildChipSection('Target Audience Age', preferences.audienceAgeRanges),
      if (preferences.targetLocations.isNotEmpty)
        _buildChipSection('Target Locations', preferences.targetLocations),
      if (preferences.budgetRange.isNotEmpty)
        _buildInfoRow('Budget Range', preferences.budgetRange),
      if (preferences.campaignGoals.isNotEmpty)
        _buildChipSection('Campaign Goals', preferences.campaignGoals),
    ]);
  }

  Widget _buildChipSection(String title, List<String> items) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children:
                items.map((item) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF4CAF50).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
