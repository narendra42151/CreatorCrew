import 'package:creatorcrew/infliencers/PrifleCreation/Models/InfluencerProfile.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfluencerProfileScreen extends StatefulWidget {
  @override
  _InfluencerProfileScreenState createState() =>
      _InfluencerProfileScreenState();
}

class _InfluencerProfileScreenState extends State<InfluencerProfileScreen> {
  bool _isLoading = true;
  InfluencerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final provider = Provider.of<InfluencerOnboardingProvider>(
      context,
      listen: false,
    );

    final profile = await provider.fetchProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'Profile not found',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProfile,
                child: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 70), // Top spacing
              _buildProfileHeader(),
              SizedBox(height: 24),
              _buildQuickStats(),
              SizedBox(height: 24),
              _buildPersonalInfo(),
              SizedBox(height: 16),
              _buildSocialMediaAccounts(),
              SizedBox(height: 16),
              _buildProfessionalInfo(),
              SizedBox(height: 16),
              _buildAdditionalInfo(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _profile!.profilePictureUrl != null
                    ? NetworkImage(_profile!.profilePictureUrl!)
                    : null,
            child:
                _profile!.profilePictureUrl == null
                    ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                    : null,
          ),
          SizedBox(height: 16),

          // Name
          Text(
            _profile!.fullName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          // Username
          Text(
            '@${_profile!.username}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),

          SizedBox(height: 12),

          // Bio
          if (_profile!.bio != null && _profile!.bio!.isNotEmpty)
            Text(
              _profile!.bio!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

          SizedBox(height: 16),

          // Categories
          if (_profile!.categories.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children:
                  _profile!.categories.take(4).map((category) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),

          SizedBox(height: 16),

          // Edit Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigate to edit profile
              },
              icon: Icon(Icons.edit, size: 16),
              label: Text('Edit Profile'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: Colors.blue),
                foregroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = _profile!.performanceMetrics;
    if (stats == null) return Container();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Followers',
            _formatNumber(stats.totalFollowers),
            Icons.people_outline,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Engagement',
            '${stats.averageEngagementRate.toStringAsFixed(1)}%',
            Icons.favorite_outline,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Views',
            _formatNumber(stats.averageViews),
            Icons.visibility_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return _buildSection('Personal Information', Icons.person_outline, [
      if (_profile!.email.isNotEmpty)
        _buildInfoItem('Email', _profile!.email, Icons.email_outlined),
      if (_profile!.phoneNumber != null && _profile!.phoneNumber!.isNotEmpty)
        _buildInfoItem('Phone', _profile!.phoneNumber!, Icons.phone_outlined),
      if (_profile!.gender != null)
        _buildInfoItem('Gender', _profile!.gender!, Icons.person_outline),
      if (_profile!.dateOfBirth != null)
        _buildInfoItem(
          'Date of Birth',
          DateFormat('MMM dd, yyyy').format(_profile!.dateOfBirth!),
          Icons.cake_outlined,
        ),
      if (_profile!.city != null && _profile!.city!.isNotEmpty)
        _buildInfoItem('City', _profile!.city!, Icons.location_city_outlined),
      if (_profile!.country != null && _profile!.country!.isNotEmpty)
        _buildInfoItem('Country', _profile!.country!, Icons.flag_outlined),
      if (_profile!.languagesSpoken.isNotEmpty) _buildLanguagesItem(),
    ]);
  }

  Widget _buildSocialMediaAccounts() {
    if (_profile!.socialMediaAccounts.isEmpty) return Container();

    return _buildSection(
      'Social Media Accounts',
      Icons.share_outlined,
      _profile!.socialMediaAccounts.map((account) {
        return _buildSocialMediaItem(account);
      }).toList(),
    );
  }

  Widget _buildSocialMediaItem(SocialMediaAccount account) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          _getPlatformIcon(account.platform),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.platform,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  '@${account.username}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatNumber(account.followerCount),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
              if (account.engagementRate != null)
                Text(
                  '${account.engagementRate!.toStringAsFixed(1)}% eng.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfo() {
    final professional = _profile!.professionalInfo;
    if (professional == null) return Container();

    List<Widget> items = [];

    // Rate Card
    if (professional.rateCard != null) {
      final rates = professional.rateCard!;
      items.add(_buildRateCardSection(rates));
    }

    // Availability
    if (professional.availability != null) {
      final availability = professional.availability!;
      items.add(_buildAvailabilitySection(availability));
    }

    // Past Collaborations
    if (professional.pastCollaborationBrands.isNotEmpty) {
      items.add(
        _buildPastCollaborationsSection(professional.pastCollaborationBrands),
      );
    }

    if (items.isEmpty) return Container();

    return _buildSection('Professional Information', Icons.work_outline, items);
  }

  Widget _buildRateCardSection(RateCard rateCard) {
    List<Widget> rates = [];

    if (rateCard.postRate != null) {
      rates.add(_buildRateItem('Post', rateCard.postRate!));
    }
    if (rateCard.storyRate != null) {
      rates.add(_buildRateItem('Story', rateCard.storyRate!));
    }
    if (rateCard.videoRate != null) {
      rates.add(_buildRateItem('Video', rateCard.videoRate!));
    }
    if (rateCard.reelRate != null) {
      rates.add(_buildRateItem('Reel', rateCard.reelRate!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rate Card',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(children: rates),
        ),
      ],
    );
  }

  Widget _buildRateItem(String type, double rate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          Text(
            '₹${_formatNumber(rate.toInt())}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection(Availability availability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            _buildAvailabilityChip('Weekdays', availability.weekdays),
            SizedBox(width: 8),
            _buildAvailabilityChip('Weekends', availability.weekends),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilityChip(String label, bool isAvailable) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAvailable ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isAvailable ? Colors.green[700] : Colors.red[700],
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPastCollaborationsSection(List<String> brands) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Collaborations',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              brands.map((brand) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Text(
                    brand,
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    final additional = _profile!.additionalInfo;
    if (additional == null) return Container();

    List<Widget> items = [];

    if (additional.gstNumber != null && additional.gstNumber!.isNotEmpty) {
      items.add(
        _buildInfoItem(
          'GST Number',
          additional.gstNumber!,
          Icons.receipt_outlined,
        ),
      );
    }
    if (additional.panNumber != null && additional.panNumber!.isNotEmpty) {
      items.add(
        _buildInfoItem(
          'PAN Number',
          additional.panNumber!,
          Icons.credit_card_outlined,
        ),
      );
    }
    if (additional.paymentMethod != null &&
        additional.paymentMethod!.isNotEmpty) {
      items.add(
        _buildInfoItem(
          'Payment Method',
          additional.paymentMethod!,
          Icons.payment_outlined,
        ),
      );
    }

    items.add(
      _buildInfoItem(
        'Member Since',
        DateFormat('MMM dd, yyyy').format(_profile!.createdAt),
        Icons.calendar_today_outlined,
      ),
    );

    if (items.isEmpty) return Container();

    return _buildSection('Additional Information', Icons.info_outline, items);
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    if (children.isEmpty) return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              Icon(icon, size: 20, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.language_outlined, size: 16, color: Colors.grey[500]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children:
                      _profile!.languagesSpoken.map((language) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            language,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPlatformIcon(String platform) {
    IconData iconData;
    Color color;

    switch (platform.toLowerCase()) {
      case 'instagram':
        iconData = Icons.camera_alt;
        color = Colors.pink;
        break;
      case 'youtube':
        iconData = Icons.play_circle_filled;
        color = Colors.red;
        break;
      case 'tiktok':
        iconData = Icons.music_note;
        color = Colors.black;
        break;
      case 'twitter':
      case 'twitter/x':
        iconData = Icons.alternate_email;
        color = Colors.blue;
        break;
      default:
        iconData = Icons.public;
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(iconData, color: color, size: 16),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
