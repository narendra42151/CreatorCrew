// // import 'dart:math';

// // import 'package:creatorcrew/Influencers/Dashboard/Screens/CampaignCreationScreen.dart';
// // import 'package:creatorcrew/Influencers/Dashboard/Screens/ShineEffect.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // // Example Home Screen Content class that utilizes the GlassmorphicAppBar
// // class BrandHomeContent extends StatefulWidget {
// //   const BrandHomeContent({Key? key}) : super(key: key);

// //   @override
// //   _BrandHomeContentState createState() => _BrandHomeContentState();
// // }

// // class _BrandHomeContentState extends State<BrandHomeContent> {
// //   String? brandName;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadBrandName();
// //   }

// //   Future<void> _loadBrandName() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       brandName = prefs.getString('brand_name');
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // The actual content of your home screen would go here
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.only(top: 90), // Extra padding for app bar
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Welcome Banner with Animation
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Container(
// //               padding: EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 gradient: LinearGradient(
// //                   colors: [
// //                     Color(0xFF4CAF50).withOpacity(0.9),
// //                     Color(0xFF2E7D32).withOpacity(0.8),
// //                   ],
// //                   begin: Alignment.topLeft,
// //                   end: Alignment.bottomRight,
// //                 ),
// //                 borderRadius: BorderRadius.circular(16),
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Color(0xFF4CAF50).withOpacity(0.3),
// //                     blurRadius: 12,
// //                     offset: Offset(0, 4),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(
// //                           "Hey ${brandName ?? 'Your Brand'} Team 👋",
// //                           style: TextStyle(
// //                             color: Colors.white,
// //                             fontWeight: FontWeight.bold,
// //                             fontSize: 18,
// //                           ),
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                       ),
// //                       SizedBox(width: 4),
// //                       // Animated Confetti Emoji
// //                       TweenAnimationBuilder(
// //                         tween: Tween<double>(begin: 0, end: 1),
// //                         duration: Duration(seconds: 1),
// //                         builder: (context, value, child) {
// //                           return Transform.scale(
// //                             scale:
// //                                 0.8 +
// //                                 (value * 0.4 * (1 + 0.1 * (sin(value * 6.28)))),
// //                             child: child,
// //                           );
// //                         },
// //                         child: Text("🎉", style: TextStyle(fontSize: 20)),
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 8),

// //                   // Performance message with subtle animation
// //                   TweenAnimationBuilder(
// //                     tween: Tween<double>(begin: 0, end: 1),
// //                     duration: Duration(milliseconds: 800),
// //                     curve: Curves.easeOutCubic,
// //                     builder: (context, value, child) {
// //                       return Opacity(
// //                         opacity: value,
// //                         child: Transform.translate(
// //                           offset: Offset(0, 10 * (1 - value)),
// //                           child: child,
// //                         ),
// //                       );
// //                     },
// //                     child: Text(
// //                       "Your latest campaign is outperforming 70% of the brands this week!",
// //                       style: TextStyle(
// //                         color: Colors.white.withOpacity(0.95),
// //                         fontWeight: FontWeight.w500,
// //                         fontSize: 15,
// //                         height: 1.3,
// //                       ),
// //                     ),
// //                   ),

// //                   SizedBox(height: 12),

// //                   // Motivational message with shine animation
// //                   ShineEffect(
// //                     child: Container(
// //                       padding: EdgeInsets.symmetric(
// //                         vertical: 8,
// //                         horizontal: 12,
// //                       ),
// //                       decoration: BoxDecoration(
// //                         color: Colors.white.withOpacity(0.15),
// //                         borderRadius: BorderRadius.circular(8),
// //                       ),
// //                       child: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           Icon(
// //                             Icons.arrow_upward_rounded,
// //                             color: Colors.white,
// //                             size: 16,
// //                           ),
// //                           SizedBox(width: 6),
// //                           Flexible(
// //                             child: Text(
// //                               "Keep the momentum going! Schedule your next post.",
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w600,
// //                                 fontSize: 13,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // Example content sections
// //           SizedBox(height: 24),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Text(
// //               "Your Dashboard",
// //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
// //             ),
// //           ),
// //           SizedBox(height: 16),

// //           // Example card
// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16),
// //             child: Card(
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(16),
// //               ),
// //               elevation: 4,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(16.0),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "Start Your First Campaign",
// //                       style: TextStyle(
// //                         fontSize: 18,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: 8),
// //                     Text(
// //                       "Create a campaign to connect with influencers and grow your brand reach.",
// //                       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
// //                     ),
// //                     SizedBox(height: 16),
// //                     ElevatedButton(
// //                       onPressed: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => CampaignCreationScreen(),
// //                           ),
// //                         );
// //                       },
// //                       style: ElevatedButton.styleFrom(
// //                         backgroundColor: Color(0xFF4CAF50),
// //                         shape: RoundedRectangleBorder(
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                       ),
// //                       child: Text("Create Campaign"),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'dart:math';

// import 'package:creatorcrew/Influencers/Dashboard/Models/CampaignModel.dart';
// import 'package:creatorcrew/Influencers/Dashboard/Screens/CampaignCreationScreen.dart';
// import 'package:creatorcrew/Influencers/Dashboard/Screens/ShineEffect.dart';
// import 'package:creatorcrew/Influencers/Dashboard/provider/campaignProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Example Home Screen Content class that utilizes the GlassmorphicAppBar
// class BrandHomeContent extends StatefulWidget {
//   const BrandHomeContent({Key? key}) : super(key: key);

//   @override
//   _BrandHomeContentState createState() => _BrandHomeContentState();
// }

// class _BrandHomeContentState extends State<BrandHomeContent>
//     with TickerProviderStateMixin {
//   String? brandName;
//   List<CampaignModel> campaigns = [];
//   bool isLoadingCampaigns = false;
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _loadBrandName();
//     _loadCampaigns();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 1500),
//       vsync: this,
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadBrandName() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       brandName = prefs.getString('brand_name');
//     });
//   }

//   Future<void> _loadCampaigns() async {
//     setState(() {
//       isLoadingCampaigns = true;
//     });

//     final campaignProvider = Provider.of<CampaignProvider>(
//       context,
//       listen: false,
//     );
//     final fetchedCampaigns = await campaignProvider.fetchCampaigns();

//     setState(() {
//       campaigns = fetchedCampaigns;
//       isLoadingCampaigns = false;
//     });
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'active':
//         return Colors.green;
//       case 'completed':
//         return Colors.blue;
//       case 'paused':
//         return Colors.orange;
//       case 'draft':
//         return Colors.grey;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'fashion':
//         return Icons.checkroom;
//       case 'tech':
//         return Icons.computer;
//       case 'food':
//         return Icons.restaurant;
//       case 'travel':
//         return Icons.flight;
//       case 'fitness':
//         return Icons.fitness_center;
//       case 'beauty':
//         return Icons.face;
//       case 'lifestyle':
//         return Icons.home;
//       default:
//         return Icons.campaign;
//     }
//   }

//   Widget _buildCampaignCard(CampaignModel campaign, int index) {
//     return TweenAnimationBuilder(
//       tween: Tween<double>(begin: 0, end: 1),
//       duration: Duration(milliseconds: 600 + (index * 100)),
//       curve: Curves.easeOutBack,
//       builder: (context, double value, child) {
//         final clampedValue = value.clamp(0.0, 1.0);
//         return Transform.translate(
//           offset: Offset(0, 30 * (1 - value)),
//           child: Opacity(
//             opacity: value,
//             child: Container(
//               margin: EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 gradient: LinearGradient(
//                   colors: [Colors.white, Color(0xFFF8F9FA)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 20,
//                     offset: Offset(0, 8),
//                     spreadRadius: 0,
//                   ),
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 5,
//                     offset: Offset(0, 2),
//                     spreadRadius: 0,
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       // Navigate to campaign details
//                     },
//                     borderRadius: BorderRadius.circular(20),
//                     child: Padding(
//                       padding: EdgeInsets.all(20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Header Row
//                           Row(
//                             children: [
//                               // Category Icon
//                               Container(
//                                 padding: EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Color(0xFF4CAF50),
//                                       Color(0xFF45A049),
//                                     ],
//                                   ),
//                                   borderRadius: BorderRadius.circular(12),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Color(0xFF4CAF50).withOpacity(0.3),
//                                       blurRadius: 8,
//                                       offset: Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Icon(
//                                   _getCategoryIcon(campaign.category),
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                               ),
//                               SizedBox(width: 12),

//                               // Title and Status
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       campaign.title,
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black87,
//                                       ),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(height: 4),
//                                     Container(
//                                       padding: EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 4,
//                                       ),
//                                       decoration: BoxDecoration(
//                                         color: _getStatusColor(
//                                           campaign.status,
//                                         ).withOpacity(0.1),
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: _getStatusColor(
//                                             campaign.status,
//                                           ).withOpacity(0.3),
//                                         ),
//                                       ),
//                                       child: Text(
//                                         campaign.status.toUpperCase(),
//                                         style: TextStyle(
//                                           fontSize: 10,
//                                           fontWeight: FontWeight.w600,
//                                           color: _getStatusColor(
//                                             campaign.status,
//                                           ),
//                                           letterSpacing: 0.5,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // More Options
//                               PopupMenuButton(
//                                 icon: Icon(
//                                   Icons.more_vert,
//                                   color: Colors.grey[600],
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 itemBuilder:
//                                     (context) => [
//                                       PopupMenuItem(
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.edit, size: 16),
//                                             SizedBox(width: 8),
//                                             Text('Edit'),
//                                           ],
//                                         ),
//                                         value: 'edit',
//                                       ),
//                                       PopupMenuItem(
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.analytics, size: 16),
//                                             SizedBox(width: 8),
//                                             Text('Analytics'),
//                                           ],
//                                         ),
//                                         value: 'analytics',
//                                       ),
//                                       PopupMenuItem(
//                                         child: Row(
//                                           children: [
//                                             Icon(Icons.share, size: 16),
//                                             SizedBox(width: 8),
//                                             Text('Share'),
//                                           ],
//                                         ),
//                                         value: 'share',
//                                       ),
//                                     ],
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: 16),

//                           // Description
//                           Text(
//                             campaign.description,
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey[700],
//                               height: 1.4,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),

//                           SizedBox(height: 16),

//                           // Platforms
//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 4,
//                             children:
//                                 campaign.platforms.map((platform) {
//                                   return Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFF4CAF50).withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     child: Text(
//                                       platform,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w500,
//                                         color: Color(0xFF2E7D32),
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                           ),

//                           SizedBox(height: 16),

//                           // Stats Row
//                           Row(
//                             children: [
//                               // Budget
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Budget',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       '₹${NumberFormat('#,##,###').format(campaign.totalBudget)}',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                         color: Color(0xFF2E7D32),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // Followers Range
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Followers',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       '${_formatFollowers(campaign.followerRangeStart)} - ${_formatFollowers(campaign.followerRangeEnd)}',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // End Date
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Ends',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.grey[600],
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       DateFormat(
//                                         'MMM dd',
//                                       ).format(campaign.endDate),
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),

//                           SizedBox(height: 16),

//                           // Action Buttons
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () {
//                                     // View applications
//                                   },
//                                   icon: Icon(Icons.people, size: 16),
//                                   label: Text('Applications'),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Color(0xFF4CAF50),
//                                     foregroundColor: Colors.white,
//                                     elevation: 0,
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 12),
//                               Expanded(
//                                 child: OutlinedButton.icon(
//                                   onPressed: () {
//                                     // View analytics
//                                   },
//                                   icon: Icon(Icons.analytics, size: 16),
//                                   label: Text('Analytics'),
//                                   style: OutlinedButton.styleFrom(
//                                     foregroundColor: Color(0xFF4CAF50),
//                                     side: BorderSide(color: Color(0xFF4CAF50)),
//                                     padding: EdgeInsets.symmetric(vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   String _formatFollowers(double followers) {
//     if (followers >= 1000000) {
//       return '${(followers / 1000000).toStringAsFixed(1)}M';
//     } else if (followers >= 1000) {
//       return '${(followers / 1000).toStringAsFixed(1)}K';
//     } else {
//       return followers.toStringAsFixed(0);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: _loadCampaigns,
//       color: Color(0xFF4CAF50),
//       child: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         padding: EdgeInsets.only(top: 90), // Extra padding for app bar
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Welcome Banner with Animation
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color(0xFF4CAF50).withOpacity(0.9),
//                       Color(0xFF2E7D32).withOpacity(0.8),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Color(0xFF4CAF50).withOpacity(0.3),
//                       blurRadius: 12,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             "Hey ${brandName ?? 'Your Brand'} Team 👋",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         SizedBox(width: 4),
//                         // Animated Confetti Emoji
//                         TweenAnimationBuilder(
//                           tween: Tween<double>(begin: 0, end: 1),
//                           duration: Duration(seconds: 1),
//                           builder: (context, value, child) {
//                             return Transform.scale(
//                               scale:
//                                   0.8 +
//                                   (value *
//                                       0.4 *
//                                       (1 + 0.1 * (sin(value * 6.28)))),
//                               child: child,
//                             );
//                           },
//                           child: Text("🎉", style: TextStyle(fontSize: 20)),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 8),

//                     // Performance message with subtle animation
//                     TweenAnimationBuilder(
//                       tween: Tween<double>(begin: 0, end: 1),
//                       duration: Duration(milliseconds: 800),
//                       curve: Curves.easeOutCubic,
//                       builder: (context, value, child) {
//                         return Opacity(
//                           opacity: value,
//                           child: Transform.translate(
//                             offset: Offset(0, 10 * (1 - value)),
//                             child: child,
//                           ),
//                         );
//                       },
//                       child: Text(
//                         campaigns.isNotEmpty
//                             ? "You have ${campaigns.length} active campaigns running!"
//                             : "Ready to create your first campaign?",
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.95),
//                           fontWeight: FontWeight.w500,
//                           fontSize: 15,
//                           height: 1.3,
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 12),

//                     // Action button
//                     ShineEffect(
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => CampaignCreationScreen(),
//                             ),
//                           ).then((_) => _loadCampaigns());
//                         },
//                         borderRadius: BorderRadius.circular(8),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             vertical: 8,
//                             horizontal: 12,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.15),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(
//                                 Icons.add_circle_outline,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                               SizedBox(width: 6),
//                               Text(
//                                 "Create New Campaign",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             SizedBox(height: 24),

//             // Campaigns Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Your Campaigns",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   if (campaigns.isNotEmpty)
//                     TextButton.icon(
//                       onPressed: () {
//                         // Navigate to all campaigns
//                       },
//                       icon: Icon(Icons.arrow_forward, size: 16),
//                       label: Text('View All'),
//                       style: TextButton.styleFrom(
//                         foregroundColor: Color(0xFF4CAF50),
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 16),

//             // Campaigns List
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child:
//                   isLoadingCampaigns
//                       ? Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(32),
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFF4CAF50),
//                             ),
//                           ),
//                         ),
//                       )
//                       : campaigns.isEmpty
//                       ? _buildEmptyState()
//                       : Column(
//                         children:
//                             campaigns
//                                 .asMap()
//                                 .entries
//                                 .map(
//                                   (entry) => _buildCampaignCard(
//                                     entry.value,
//                                     entry.key,
//                                   ),
//                                 )
//                                 .toList(),
//                       ),
//             ),

//             SizedBox(height: 80), // Bottom padding
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Container(
//       padding: EdgeInsets.all(32),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
//           SizedBox(height: 16),
//           Text(
//             "No Campaigns Yet",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             "Create your first campaign to start connecting with influencers",
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               height: 1.4,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CampaignCreationScreen(),
//                 ),
//               ).then((_) => _loadCampaigns());
//             },
//             icon: Icon(Icons.add),
//             label: Text("Create Campaign"),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF4CAF50),
//               foregroundColor: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:math';

import 'package:creatorcrew/Influencers/Dashboard/Models/CampaignModel.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/CampaignCreationScreen.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/ShineEffect.dart';
import 'package:creatorcrew/Influencers/Dashboard/provider/campaignProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Example Home Screen Content class that utilizes the GlassmorphicAppBar
class BrandHomeContent extends StatefulWidget {
  const BrandHomeContent({Key? key}) : super(key: key);

  @override
  _BrandHomeContentState createState() => _BrandHomeContentState();
}

class _BrandHomeContentState extends State<BrandHomeContent>
    with TickerProviderStateMixin {
  String? brandName;
  List<CampaignModel> campaigns = [];
  bool isLoadingCampaigns = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadBrandName();
    _loadCampaigns();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadBrandName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brandName = prefs.getString('brand_name');
    });
  }

  Future<void> _loadCampaigns() async {
    setState(() {
      isLoadingCampaigns = true;
    });

    try {
      final campaignProvider = Provider.of<CampaignProvider>(
        context,
        listen: false,
      );
      final fetchedCampaigns = await campaignProvider.fetchCampaigns();

      setState(() {
        campaigns = fetchedCampaigns;
        isLoadingCampaigns = false;
      });
    } catch (e) {
      print('Error loading campaigns: $e');
      setState(() {
        isLoadingCampaigns = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fashion':
        return Icons.checkroom;
      case 'tech':
        return Icons.computer;
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'fitness':
        return Icons.fitness_center;
      case 'beauty':
        return Icons.face;
      case 'lifestyle':
        return Icons.home;
      default:
        return Icons.campaign;
    }
  }

  Widget _buildCampaignCard(CampaignModel campaign, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        // Clamp the value to ensure it's between 0.0 and 1.0
        final clampedValue = value.clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(0, 30 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFF8F9FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Navigate to campaign details
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              // Category Icon
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF4CAF50),
                                      Color(0xFF45A049),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF4CAF50).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getCategoryIcon(campaign.category),
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),

                              // Title and Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      campaign.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          campaign.status,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getStatusColor(
                                            campaign.status,
                                          ).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        campaign.status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(
                                            campaign.status,
                                          ),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // More Options
                              PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[600],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                itemBuilder:
                                    (context) => [
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 16),
                                            SizedBox(width: 8),
                                            Text('Edit'),
                                          ],
                                        ),
                                        value: 'edit',
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.analytics, size: 16),
                                            SizedBox(width: 8),
                                            Text('Analytics'),
                                          ],
                                        ),
                                        value: 'analytics',
                                      ),
                                      PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.share, size: 16),
                                            SizedBox(width: 8),
                                            Text('Share'),
                                          ],
                                        ),
                                        value: 'share',
                                      ),
                                    ],
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Description
                          Text(
                            campaign.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 16),

                          // Platforms
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                campaign.platforms.map((platform) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4CAF50).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      platform,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),

                          SizedBox(height: 16),

                          // Stats Row
                          Row(
                            children: [
                              // Budget
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Budget',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '₹${NumberFormat('#,##,###').format(campaign.totalBudget)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Followers Range
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Followers',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${_formatFollowers(campaign.followerRangeStart)} - ${_formatFollowers(campaign.followerRangeEnd)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // End Date
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ends',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'MMM dd',
                                      ).format(campaign.endDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // View applications
                                  },
                                  icon: Icon(Icons.people, size: 16),
                                  label: Text('Applications'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF4CAF50),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // View analytics
                                  },
                                  icon: Icon(Icons.analytics, size: 16),
                                  label: Text('Analytics'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Color(0xFF4CAF50),
                                    side: BorderSide(color: Color(0xFF4CAF50)),
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatFollowers(double followers) {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    } else {
      return followers.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadCampaigns,
      color: Color(0xFF4CAF50),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 90), // Extra padding for app bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner with Animation
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(16),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Hey ${brandName ?? 'Your Brand'} Team 👋",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4),
                        // Animated Confetti Emoji - Fixed animation
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(seconds: 1),
                          builder: (context, value, child) {
                            // Clamp value and fix the scale calculation
                            final clampedValue = value.clamp(0.0, 1.0);
                            final scale =
                                0.8 +
                                (clampedValue *
                                    0.4 *
                                    (1 + 0.1 * sin(clampedValue * 6.28)));
                            final clampedScale = scale.clamp(
                              0.1,
                              2.0,
                            ); // Ensure scale is reasonable

                            return Transform.scale(
                              scale: clampedScale,
                              child: child,
                            );
                          },
                          child: Text("🎉", style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Performance message with subtle animation - Fixed
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        final clampedValue = value.clamp(0.0, 1.0);
                        return Opacity(
                          opacity: clampedValue,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - clampedValue)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        campaigns.isNotEmpty
                            ? "You have ${campaigns.length} active campaigns running!"
                            : "Ready to create your first campaign?",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Action button
                    ShineEffect(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CampaignCreationScreen(),
                            ),
                          ).then((_) => _loadCampaigns());
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Create New Campaign",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            // Campaigns Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Campaigns",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  if (campaigns.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to all campaigns
                      },
                      icon: Icon(Icons.arrow_forward, size: 16),
                      label: Text('View All'),
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF4CAF50),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Campaigns List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child:
                  isLoadingCampaigns
                      ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      )
                      : campaigns.isEmpty
                      ? _buildEmptyState()
                      : Column(
                        children:
                            campaigns
                                .asMap()
                                .entries
                                .map(
                                  (entry) => _buildCampaignCard(
                                    entry.value,
                                    entry.key,
                                  ),
                                )
                                .toList(),
                      ),
            ),

            SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(Icons.campaign_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "No Campaigns Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Create your first campaign to start connecting with influencers",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CampaignCreationScreen(),
                ),
              ).then((_) => _loadCampaigns());
            },
            icon: Icon(Icons.add),
            label: Text("Create Campaign"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
