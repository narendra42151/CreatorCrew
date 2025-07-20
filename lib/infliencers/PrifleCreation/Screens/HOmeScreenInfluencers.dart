// import 'package:creatorcrew/Brand/Dashboard/Models/CampaignModel.dart';
// import 'package:creatorcrew/Brand/Dashboard/provider/campaignProvider.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/Screens/influencerSeasionManager.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/providers/Stats/InfluencerStatsProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class InfluencerHomeScreen extends StatefulWidget {
//   @override
//   _InfluencerHomeScreenState createState() => _InfluencerHomeScreenState();
// }

// class _InfluencerHomeScreenState extends State<InfluencerHomeScreen> {
//   String? influencerName;
//   List<CampaignModel> hotCampaigns = [];
//   String? influencerCategory;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   // Future<void> _loadData() async {
//   //   final data = await InfluencerSessionManager.getInfluencerData();
//   //   final campaignProvider = Provider.of<CampaignProvider>(
//   //     context,
//   //     listen: false,
//   //   );

//   //   final campaigns = await campaignProvider.fetchCampaigns();

//   //   setState(() {
//   //     influencerName = data['name']?.split(' ')[0] ?? 'Creator';
//   //     hotCampaigns = campaigns.take(5).toList(); // Show first 5 campaigns
//   //     isLoading = false;
//   //   });
//   // }
//   Future<void> _loadData() async {
//     final data = await InfluencerSessionManager.getInfluencerData();
//     final campaignProvider = Provider.of<CampaignProvider>(
//       context,
//       listen: false,
//     );

//     // Fetch all active campaigns instead of brand campaigns
//     final allCampaigns = await campaignProvider.fetchAllActiveCampaigns();

//     // Get influencer's category/niche
//     final influencerNiche = data['category'] ?? data['niche'] ?? '';

//     // Filter campaigns based on matching categories
//     List<CampaignModel> filteredCampaigns = [];

//     if (influencerNiche.isNotEmpty) {
//       filteredCampaigns =
//           allCampaigns.where((campaign) {
//             // Case-insensitive category matching
//             return campaign.category.toLowerCase() ==
//                     influencerNiche.toLowerCase() ||
//                 campaign.category.toLowerCase().contains(
//                   influencerNiche.toLowerCase(),
//                 ) ||
//                 influencerNiche.toLowerCase().contains(
//                   campaign.category.toLowerCase(),
//                 );
//           }).toList();
//       if (filteredCampaigns.isEmpty) {
//         filteredCampaigns =
//             allCampaigns.where((campaign) {
//               final generalCategories = [
//                 'general',
//                 'lifestyle',
//                 'brand awareness',
//                 'all categories',
//               ];
//               return generalCategories.any(
//                 (general) => campaign.category.toLowerCase().contains(
//                   general.toLowerCase(),
//                 ),
//               );
//             }).toList();
//       }
//     } else {
//       // If no category specified, show all campaigns
//       filteredCampaigns = allCampaigns;
//     }
//     final statsProvider = Provider.of<InfluencerStatsProvider>(context, listen: false);
//     await statsProvider.fetchAllStats(context);

//     setState(() {
//       influencerName = data['name']?.split(' ')[0] ?? 'Creator';
//       influencerCategory = influencerNiche;
//       hotCampaigns =
//           filteredCampaigns.take(5).toList(); // Show first 5 filtered campaigns
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: SingleChildScrollView(
//           physics: AlwaysScrollableScrollPhysics(),
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 90), // Account for app bar
//               _buildWelcomeSection(),
//               SizedBox(height: 24),
//               _buildQuickStatsSection(),
//               SizedBox(height: 24),
//               _buildHotCampaignsSection(),
//               SizedBox(height: 24),
//               _buildRecentActivitySection(),
//               SizedBox(height: 24),
//               _buildTipsInsightsSection(),
//               SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.blue.shade400, Colors.purple.shade400],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 15,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text('👋', style: TextStyle(fontSize: 24)),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Hey, $influencerName!',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Let\'s grow your influence today!',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               '🎯 ${_getMotivationalMessage()}',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStatsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('📊', style: TextStyle(fontSize: 20)),
//             SizedBox(width: 8),
//             Text(
//               'Quick Stats',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 16),
//         Consumer<InfluencerStatsProvider>(
//           builder: (context, statsProvider, child) {
//             if (statsProvider.isLoading) {
//               return _buildLoadingStats();
//             }

//             final stats = statsProvider.stats;
//             return Column(
//               children: [
//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 '💰',
//                 'Total Earnings',
//                 '₹3,200',
//                 Colors.green,
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: _buildStatCard('📋', 'Active Campaigns', '4', Colors.blue),
//             ),
//           ],
//         ),
//         SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: _buildStatCard(
//                 '⏳',
//                 'Pending Submissions',
//                 '2',
//                 Colors.orange,
//               ),
//             ),
//             SizedBox(width: 12),
//             Expanded(
//               child: _buildStatCard(
//                 '🗓',
//                 'Today\'s Meetings',
//                 '1',
//                 Colors.purple,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(String emoji, String label, String value, Color color) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//         border: Border.all(color: color.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(emoji, style: TextStyle(fontSize: 20)),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Icon(Icons.trending_up, color: color, size: 12),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: color,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildHotCampaignsSection() {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       Row(
//   //         children: [
//   //           Text('🔥', style: TextStyle(fontSize: 20)),
//   //           SizedBox(width: 8),
//   //           Text(
//   //             'Hot Campaigns for You',
//   //             style: TextStyle(
//   //               fontSize: 18,
//   //               fontWeight: FontWeight.bold,
//   //               color: Colors.black87,
//   //             ),
//   //           ),
//   //           Spacer(),
//   //           TextButton(
//   //             onPressed: () {
//   //               // Navigate to campaigns page
//   //             },
//   //             child: Text('View All'),
//   //           ),
//   //         ],
//   //       ),
//   //       SizedBox(height: 16),
//   //       if (isLoading)
//   //         Center(child: CircularProgressIndicator())
//   //       else if (hotCampaigns.isEmpty)
//   //         _buildNoCampaignsCard()
//   //       else
//   //         Container(
//   //           height: 200,
//   //           child: ListView.builder(
//   //             scrollDirection: Axis.horizontal,
//   //             itemCount: hotCampaigns.length,
//   //             itemBuilder: (context, index) {
//   //               return _buildCampaignCard(hotCampaigns[index]);
//   //             },
//   //           ),
//   //         ),
//   //     ],
//   //   );
//   // }

//   Widget _buildHotCampaignsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('🔥', style: TextStyle(fontSize: 20)),
//             SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Hot Campaigns for You',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   if (influencerCategory != null &&
//                       influencerCategory!.isNotEmpty)
//                     Text(
//                       'Matched with your ${influencerCategory} category',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to campaigns page
//               },
//               child: Text('View All'),
//             ),
//           ],
//         ),
//         SizedBox(height: 16),
//         if (isLoading)
//           Center(child: CircularProgressIndicator())
//         else if (hotCampaigns.isEmpty)
//           _buildNoCampaignsCard()
//         else
//           Container(
//             height: 200,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: hotCampaigns.length,
//               itemBuilder: (context, index) {
//                 return _buildCampaignCard(hotCampaigns[index]);
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildCampaignCard(CampaignModel campaign) {
//     return Container(
//       width: 280,
//       margin: EdgeInsets.only(right: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(Icons.business, color: Colors.blue, size: 20),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       campaign.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     Text(
//                       campaign.category,
//                       style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 12),
//           Text(
//             campaign.description,
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontSize: 12,
//               height: 1.3,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 12),
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   '₹${_formatBudget(campaign.budgetPerInfluencer)}',
//                   style: TextStyle(
//                     color: Colors.green[700],
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   campaign.platforms.first,
//                   style: TextStyle(
//                     color: Colors.blue[700],
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 // Apply to campaign
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text(
//                 'Apply Now',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoCampaignsCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.campaign_outlined, size: 48, color: Colors.grey[400]),
//           SizedBox(height: 12),
//           Text(
//             'No campaigns available right now',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Check back soon for new opportunities!',
//             style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentActivitySection() {
//     final activities = [
//       {
//         'icon': '✅',
//         'text': 'Applied to "Mamaearth Winter Promo"',
//         'time': '2 hours ago',
//       },
//       {
//         'icon': '📩',
//         'text': 'Submitted content for "Zomato Xperience"',
//         'time': '1 day ago',
//       },
//       {
//         'icon': '💵',
//         'text': 'Received ₹1200 from "Tata 1mg"',
//         'time': '2 days ago',
//       },
//       {
//         'icon': '📅',
//         'text': 'Meeting booked with "CRED" for 5 PM',
//         'time': '3 days ago',
//       },
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('🕓', style: TextStyle(fontSize: 20)),
//             SizedBox(width: 8),
//             Text(
//               'Recent Activity',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 16),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 10,
//                 offset: Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             children:
//                 activities.map((activity) {
//                   return _buildActivityItem(
//                     activity['icon']!,
//                     activity['text']!,
//                     activity['time']!,
//                     activities.indexOf(activity) != activities.length - 1,
//                   );
//                 }).toList(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActivityItem(
//     String icon,
//     String text,
//     String time,
//     bool showDivider,
//   ) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Text(icon, style: TextStyle(fontSize: 16)),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       text,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       time,
//                       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (showDivider) ...[
//             SizedBox(height: 16),
//             Divider(height: 1, color: Colors.grey[200]),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildTipsInsightsSection() {
//     final tips = [
//       {
//         'icon': '🎯',
//         'title': 'How to increase your brand appeal',
//         'description': 'Focus on consistent posting and authentic engagement',
//       },
//       {
//         'icon': '⏰',
//         'title': 'Best times to post for max engagement',
//         'description': 'Peak hours are 6-9 PM and 8-11 AM on weekdays',
//       },
//       {
//         'icon': '✨',
//         'title': 'Avoiding rejection: content dos and don\'ts',
//         'description': 'Always read brand guidelines carefully before creating',
//       },
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text('💡', style: TextStyle(fontSize: 20)),
//             SizedBox(width: 8),
//             Text(
//               'Tips & Insights',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 16),
//         Column(
//           children:
//               tips.map((tip) {
//                 return Container(
//                   margin: EdgeInsets.only(bottom: 12),
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 8,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Text(tip['icon']!, style: TextStyle(fontSize: 20)),
//                       SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               tip['title']!,
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             SizedBox(height: 4),
//                             Text(
//                               tip['description']!,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                                 height: 1.3,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Icon(
//                         Icons.arrow_forward_ios,
//                         size: 14,
//                         color: Colors.grey[400],
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//         ),
//       ],
//     );
//   }

//   String _getMotivationalMessage() {
//     final messages = [
//       'Your next big collaboration awaits!',
//       'Keep creating amazing content!',
//       'You\'re building something great!',
//       'Your influence is growing every day!',
//     ];
//     return messages[DateTime.now().day % messages.length];
//   }

//   String _formatBudget(double budget) {
//     if (budget >= 100000) {
//       return '${(budget / 100000).toStringAsFixed(1)}L';
//     } else if (budget >= 1000) {
//       return '${(budget / 1000).toStringAsFixed(1)}K';
//     }
//     return budget.toStringAsFixed(0);
//   }
// }
import 'package:creatorcrew/Brand/Dashboard/Models/CampaignModel.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/campaignProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/influencerSeasionManager.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/Stats/InfluencerStatsProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfluencerHomeScreen extends StatefulWidget {
  @override
  _InfluencerHomeScreenState createState() => _InfluencerHomeScreenState();
}

class _InfluencerHomeScreenState extends State<InfluencerHomeScreen> {
  String? influencerName;
  List<CampaignModel> hotCampaigns = [];
  String? influencerCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await InfluencerSessionManager.getInfluencerData();
    final campaignProvider = Provider.of<CampaignProvider>(
      context,
      listen: false,
    );

    // Fetch all active campaigns instead of brand campaigns
    final allCampaigns = await campaignProvider.fetchAllActiveCampaigns();

    // Get influencer's category/niche
    final influencerNiche = data['category'] ?? data['niche'] ?? '';

    // Filter campaigns based on matching categories
    List<CampaignModel> filteredCampaigns = [];

    if (influencerNiche.isNotEmpty) {
      filteredCampaigns =
          allCampaigns.where((campaign) {
            // Case-insensitive category matching
            return campaign.category.toLowerCase() ==
                    influencerNiche.toLowerCase() ||
                campaign.category.toLowerCase().contains(
                  influencerNiche.toLowerCase(),
                ) ||
                influencerNiche.toLowerCase().contains(
                  campaign.category.toLowerCase(),
                );
          }).toList();
      if (filteredCampaigns.isEmpty) {
        filteredCampaigns =
            allCampaigns.where((campaign) {
              final generalCategories = [
                'general',
                'lifestyle',
                'brand awareness',
                'all categories',
              ];
              return generalCategories.any(
                (general) => campaign.category.toLowerCase().contains(
                  general.toLowerCase(),
                ),
              );
            }).toList();
      }
    } else {
      // If no category specified, show all campaigns
      filteredCampaigns = allCampaigns;
    }

    // Fetch stats
    final statsProvider = Provider.of<InfluencerStatsProvider>(
      context,
      listen: false,
    );
    await statsProvider.fetchAllStats(context);

    setState(() {
      influencerName = data['name']?.split(' ')[0] ?? 'Creator';
      influencerCategory = influencerNiche;
      hotCampaigns =
          filteredCampaigns.take(5).toList(); // Show first 5 filtered campaigns
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 90), // Account for app bar
              _buildWelcomeSection(),
              SizedBox(height: 24),
              _buildQuickStatsSection(),
              SizedBox(height: 24),
              _buildHotCampaignsSection(),
              SizedBox(height: 24),
              _buildRecentActivitySection(),
              SizedBox(height: 24),
              _buildTipsInsightsSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('👋', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hey, $influencerName!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Let\'s grow your influence today!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '🎯 ${_getMotivationalMessage()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('📊', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Consumer<InfluencerStatsProvider>(
          builder: (context, statsProvider, child) {
            if (statsProvider.isLoading) {
              return _buildLoadingStats();
            }

            final stats = statsProvider.stats;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '💰',
                        'Total Earnings',
                        '₹${_formatCurrency(stats['totalEarnings'])}',
                        Colors.green,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '📋',
                        'Active Campaigns',
                        '${stats['activeCampaigns']}',
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '⏳',
                        'Pending Submissions',
                        '${stats['pendingSubmissions']}',
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '🗓',
                        'Today\'s Meetings',
                        '${stats['todaysMeetings']}',
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLoadingStatCard()),
            SizedBox(width: 12),
            Expanded(child: _buildLoadingStatCard()),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildLoadingStatCard()),
            SizedBox(width: 12),
            Expanded(child: _buildLoadingStatCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingStatCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Spacer(),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: 60,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: 80,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String emoji, String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 20)),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.trending_up, color: color, size: 12),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotCampaignsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🔥', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hot Campaigns for You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (influencerCategory != null &&
                      influencerCategory!.isNotEmpty)
                    Text(
                      'Matched with your ${influencerCategory} category',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to campaigns page
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (isLoading)
          Center(child: CircularProgressIndicator())
        else if (hotCampaigns.isEmpty)
          _buildNoCampaignsCard()
        else
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hotCampaigns.length,
              itemBuilder: (context, index) {
                return _buildCampaignCard(hotCampaigns[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCampaignCard(CampaignModel campaign) {
    return Container(
      width: 280,
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.business, color: Colors.blue, size: 20),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      campaign.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      campaign.category,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            campaign.description,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 12,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '₹${_formatBudget(campaign.budgetPerInfluencer)}',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  campaign.platforms.isNotEmpty
                      ? campaign.platforms.first
                      : 'Social',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Apply to campaign
                _showApplicationDialog(campaign);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Apply Now',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCampaignsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.campaign_outlined, size: 48, color: Colors.grey[400]),
          SizedBox(height: 12),
          Text(
            'No campaigns available right now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check back soon for new opportunities!',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final activities = [
      {
        'icon': '✅',
        'text': 'Applied to "Mamaearth Winter Promo"',
        'time': '2 hours ago',
      },
      {
        'icon': '📩',
        'text': 'Submitted content for "Zomato Xperience"',
        'time': '1 day ago',
      },
      {
        'icon': '💵',
        'text': 'Received ₹1200 from "Tata 1mg"',
        'time': '2 days ago',
      },
      {
        'icon': '📅',
        'text': 'Meeting booked with "CRED" for 5 PM',
        'time': '3 days ago',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('🕓', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children:
                activities.map((activity) {
                  return _buildActivityItem(
                    activity['icon']!,
                    activity['text']!,
                    activity['time']!,
                    activities.indexOf(activity) != activities.length - 1,
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String icon,
    String text,
    String time,
    bool showDivider,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 16)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      time,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey[200]),
          ],
        ],
      ),
    );
  }

  Widget _buildTipsInsightsSection() {
    final tips = [
      {
        'icon': '🎯',
        'title': 'How to increase your brand appeal',
        'description': 'Focus on consistent posting and authentic engagement',
      },
      {
        'icon': '⏰',
        'title': 'Best times to post for max engagement',
        'description': 'Peak hours are 6-9 PM and 8-11 AM on weekdays',
      },
      {
        'icon': '✨',
        'title': 'Avoiding rejection: content dos and don\'ts',
        'description': 'Always read brand guidelines carefully before creating',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('💡', style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Text(
              'Tips & Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children:
              tips.map((tip) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(tip['icon']!, style: TextStyle(fontSize: 20)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              tip['description']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  void _showApplicationDialog(CampaignModel campaign) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apply to Campaign'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Campaign: ${campaign.title}'),
              SizedBox(height: 8),
              Text('Budget: ₹${_formatBudget(campaign.budgetPerInfluencer)}'),
              SizedBox(height: 8),
              Text('Category: ${campaign.category}'),
              SizedBox(height: 16),
              Text('Are you sure you want to apply to this campaign?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _applyToCampaign(campaign);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyToCampaign(CampaignModel campaign) {
    // Implement application logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application submitted for ${campaign.title}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getMotivationalMessage() {
    final messages = [
      'Your next big collaboration awaits!',
      'Keep creating amazing content!',
      'You\'re building something great!',
      'Your influence is growing every day!',
    ];
    return messages[DateTime.now().day % messages.length];
  }

  String _formatBudget(double budget) {
    if (budget >= 100000) {
      return '${(budget / 100000).toStringAsFixed(1)}L';
    } else if (budget >= 1000) {
      return '${(budget / 1000).toStringAsFixed(1)}K';
    }
    return budget.toStringAsFixed(0);
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
