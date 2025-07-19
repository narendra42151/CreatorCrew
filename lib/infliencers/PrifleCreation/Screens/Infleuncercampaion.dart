import 'package:creatorcrew/Brand/Dashboard/Models/CampaignModel.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/campaignProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfluencerCampaignsScreen extends StatefulWidget {
  @override
  _InfluencerCampaignsScreenState createState() =>
      _InfluencerCampaignsScreenState();
}

class _InfluencerCampaignsScreenState extends State<InfluencerCampaignsScreen> {
  List<CampaignModel> _campaigns = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Tech',
    'Fashion',
    'Food',
    'Travel',
    'Beauty',
    'Health',
    'Lifestyle',
    'Gaming',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final campaignProvider = Provider.of<CampaignProvider>(
        context,
        listen: false,
      );
      final campaigns = await campaignProvider.fetchAllActiveCampaigns();
      setState(() {
        _campaigns = campaigns;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading campaigns: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<CampaignModel> get _filteredCampaigns {
    return _campaigns.where((campaign) {
      final matchesCategory =
          _selectedCategory == 'All' || campaign.category == _selectedCategory;
      final matchesSearch =
          campaign.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          campaign.description.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          SizedBox(height: 30),
          // Header Section with reduced height
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: BoxDecoration(
              color: Colors.white,
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
                SizedBox(height: 60), // Reduced top spacing
                // Title and stats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campaigns',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${_filteredCampaigns.length} opportunities available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.campaign, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Live',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Search Bar and Filter Dropdown in a Row
                Row(
                  children: [
                    // Search Bar
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search campaigns...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Category Filter Dropdown
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            icon: Icon(
                              Icons.filter_list,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            items:
                                _categories.map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getCategoryIcon(category),
                                          size: 16,
                                          color: _getCategoryColor(category),
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            category,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              }
                            },
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            elevation: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Campaigns List
          Expanded(
            child:
                _isLoading
                    ? _buildLoadingState()
                    : _filteredCampaigns.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                      onRefresh: _loadCampaigns,
                      color: Colors.blue,
                      child: ListView.builder(
                        padding: EdgeInsets.all(20),
                        itemCount: _filteredCampaigns.length,
                        itemBuilder: (context, index) {
                          return _buildCampaignCard(_filteredCampaigns[index]);
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Loading amazing campaigns...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.campaign_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No campaigns found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              _selectedCategory != 'All'
                  ? 'No campaigns in "$_selectedCategory" category'
                  : 'Try adjusting your search or filters',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadCampaigns,
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_selectedCategory != 'All') ...[
                  SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                      });
                    },
                    icon: Icon(Icons.clear),
                    label: Text('Clear Filter'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignCard(CampaignModel campaign) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCampaignDetails(campaign),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with category and bookmark
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getCategoryColor(campaign.category),
                            _getCategoryColor(
                              campaign.category,
                            ).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getCategoryIcon(campaign.category),
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            campaign.category,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Title and description
                Text(
                  campaign.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  campaign.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16),

                // Stats row
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          Icons.people_outline,
                          '${(campaign.followerRangeStart / 1000).toStringAsFixed(0)}K-${(campaign.followerRangeEnd / 1000).toStringAsFixed(0)}K',
                          'Followers',
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[300]),
                      Expanded(
                        child: _buildStatItem(
                          Icons.location_on_outlined,
                          campaign.location,
                          'Location',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Budget and date row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              color: Colors.green[700],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${campaign.budgetPerInfluencer.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blue[700],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                DateFormat('MMM dd').format(campaign.startDate),
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Platforms
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      campaign.platforms.map((platform) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple[200]!),
                          ),
                          child: Text(
                            platform,
                            style: TextStyle(
                              color: Colors.purple[700],
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                ),
                SizedBox(height: 16),

                // Apply button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _applyCampaign(campaign),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Apply Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Colors.blue;
      case 'fashion':
        return Colors.pink;
      case 'food':
        return Colors.orange;
      case 'travel':
        return Colors.green;
      case 'beauty':
        return Colors.purple;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.teal;
      case 'gaming':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return Icons.computer;
      case 'fashion':
        return Icons.style;
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'beauty':
        return Icons.face;
      case 'health':
        return Icons.health_and_safety;
      case 'lifestyle':
        return Icons.home;
      case 'gaming':
        return Icons.games;
      case 'all':
        return Icons.apps;
      default:
        return Icons.business;
    }
  }

  void _showCampaignDetails(CampaignModel campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getCategoryColor(campaign.category),
                                    _getCategoryColor(
                                      campaign.category,
                                    ).withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                campaign.category,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        Text(
                          campaign.title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),

                        _buildDetailSection('📝 Description', [
                          campaign.description,
                        ]),

                        _buildDetailSection('🎯 Requirements', [
                          'Followers: ${(campaign.followerRangeStart / 1000).toStringAsFixed(0)}K - ${(campaign.followerRangeEnd / 1000).toStringAsFixed(0)}K',
                          'Location: ${campaign.location}',
                          'Language: ${campaign.language}',
                        ]),

                        _buildDetailSection('📱 Content Types', [
                          if (campaign.hasImagePost) 'Image Posts',
                          if (campaign.hasVideo) 'Videos',
                          if (campaign.hasStory) 'Stories',
                          if (campaign.hasReelShort) 'Reels/Shorts',
                        ]),

                        _buildDetailSection('📅 Campaign Duration', [
                          'Start: ${DateFormat('MMM dd, yyyy').format(campaign.startDate)}',
                          'End: ${DateFormat('MMM dd, yyyy').format(campaign.endDate)}',
                          if (campaign.preferredTime != null)
                            'Preferred time: ${campaign.preferredTime}',
                        ]),

                        SizedBox(height: 32),

                        // Apply button
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _applyCampaign(campaign),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Apply for Campaign',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailSection(String title, List<String> items) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children:
                  items
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(
                            bottom: items.last == item ? 0 : 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 2),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // void _applyCampaign(CampaignModel campaign) {
  //   // Don't pop here if we're showing from a bottom sheet
  //   // Navigator.pop(context); // Remove this line

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         title: Row(
  //           children: [
  //             Icon(Icons.campaign, color: Colors.blue),
  //             SizedBox(width: 8),
  //             Expanded(
  //               child: Text(
  //                 'Apply for Campaign',
  //                 style: TextStyle(fontSize: 18),
  //               ),
  //             ),
  //           ],
  //         ),
  //         content: Text('Do you want to apply for "${campaign.title}"?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(dialogContext).pop(),
  //             child: Text('Cancel'),
  //             style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               // Close the dialog first
  //               Navigator.of(dialogContext).pop();

  //               // If we're in a bottom sheet, close it too
  //               if (Navigator.canPop(context)) {
  //                 Navigator.pop(context);
  //               }

  //               // Show success message using the original context
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   content: Row(
  //                     children: [
  //                       Icon(Icons.check_circle, color: Colors.white),
  //                       SizedBox(width: 8),
  //                       Expanded(
  //                         child: Text(
  //                           'Application submitted for ${campaign.title}',
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   backgroundColor: Colors.green,
  //                   behavior: SnackBarBehavior.floating,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //               );
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               foregroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             child: Text('Apply'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  void _applyCampaign(CampaignModel campaign) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.campaign, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Apply for Campaign',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Campaign: "${campaign.title}"'),
              SizedBox(height: 16),
              Text(
                'Add a message (optional):',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      'Tell the brand why you\'re perfect for this campaign...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
            ElevatedButton(
              onPressed: () async {
                // Close the dialog first
                Navigator.of(dialogContext).pop();

                // If we're in a bottom sheet, close it too
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }

                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => Center(child: CircularProgressIndicator()),
                );

                // Submit application
                final applicationProvider = Provider.of<ApplicationProvider>(
                  context,
                  listen: false,
                );

                final error = await applicationProvider.submitApplication(
                  campaignId: campaign.id!,
                  brandId: campaign.brandId,
                  campaignTitle: campaign.title,
                  message:
                      messageController.text.trim().isNotEmpty
                          ? messageController.text.trim()
                          : null,
                );

                // Close loading dialog
                Navigator.pop(context);

                // Show result
                if (error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Application submitted successfully!',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Submit Application'),
            ),
          ],
        );
      },
    );
  }
}
