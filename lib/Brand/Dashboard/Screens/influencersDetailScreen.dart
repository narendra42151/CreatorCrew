// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class InfluencerDetailScreen extends StatefulWidget {
//   final ApplicationModel application;

//   const InfluencerDetailScreen({Key? key, required this.application})
//     : super(key: key);

//   @override
//   _InfluencerDetailScreenState createState() => _InfluencerDetailScreenState();
// }

// class _InfluencerDetailScreenState extends State<InfluencerDetailScreen>
//     with TickerProviderStateMixin {
//   Map<String, dynamic>? influencerData;
//   bool isLoading = true;
//   bool isUpdating = false;
//   late AnimationController _animationController;
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _tabController = TabController(length: 4, vsync: this);
//     _loadInfluencerDetails();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Future<void> _loadInfluencerDetails() async {
//   //   try {
//   //     print(
//   //       'Loading influencer details for ID: ${widget.application.influencerId}',
//   //     );

//   //     // First, try to get from 'influencers' collection
//   //     DocumentSnapshot doc =
//   //         await FirebaseFirestore.instance
//   //             .collection('influencers')
//   //             .doc(widget.application.influencerId)
//   //             .get();

//   //     if (doc.exists) {
//   //       print('Found in influencers collection: ${doc.data()}');
//   //       setState(() {
//   //         influencerData = doc.data() as Map<String, dynamic>?;
//   //         isLoading = false;
//   //       });
//   //       _animationController.forward();
//   //       return;
//   //     }

//   //     // If not found, try 'users' collection
//   //     doc =
//   //         await FirebaseFirestore.instance
//   //             .collection('users')
//   //             .doc(widget.application.influencerId)
//   //             .get();

//   //     if (doc.exists) {
//   //       print('Found in users collection: ${doc.data()}');
//   //       setState(() {
//   //         influencerData = doc.data() as Map<String, dynamic>?;
//   //         isLoading = false;
//   //       });
//   //       _animationController.forward();
//   //       return;
//   //     }

//   //     // If not found, try 'profiles' collection
//   //     doc =
//   //         await FirebaseFirestore.instance
//   //             .collection('profiles')
//   //             .doc(widget.application.influencerId)
//   //             .get();

//   //     if (doc.exists) {
//   //       print('Found in profiles collection: ${doc.data()}');
//   //       setState(() {
//   //         influencerData = doc.data() as Map<String, dynamic>?;
//   //         isLoading = false;
//   //       });
//   //       _animationController.forward();
//   //       return;
//   //     }

//   //     // If still not found, try querying by email
//   //     QuerySnapshot querySnapshot =
//   //         await FirebaseFirestore.instance
//   //             .collection('influencers')
//   //             .where('email', isEqualTo: widget.application.influencerEmail)
//   //             .get();

//   //     if (querySnapshot.docs.isNotEmpty) {
//   //       print('Found by email query: ${querySnapshot.docs.first.data()}');
//   //       setState(() {
//   //         influencerData =
//   //             querySnapshot.docs.first.data() as Map<String, dynamic>?;
//   //         isLoading = false;
//   //       });
//   //       _animationController.forward();
//   //       return;
//   //     }

//   //     // Try users collection by email
//   //     querySnapshot =
//   //         await FirebaseFirestore.instance
//   //             .collection('users')
//   //             .where('email', isEqualTo: widget.application.influencerEmail)
//   //             .get();

//   //     if (querySnapshot.docs.isNotEmpty) {
//   //       print('Found in users by email: ${querySnapshot.docs.first.data()}');
//   //       setState(() {
//   //         influencerData =
//   //             querySnapshot.docs.first.data() as Map<String, dynamic>?;
//   //         isLoading = false;
//   //       });
//   //       _animationController.forward();
//   //       return;
//   //     }

//   //     print('No influencer data found in any collection');
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   } catch (e) {
//   //     print('Error loading influencer details: $e');
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   }
//   // }
//   Future<void> _loadInfluencerDetails() async {
//     try {
//       print(
//         'Loading influencer details for ID: ${widget.application.influencerId}',
//       );

//       // First, try to get from 'influencers' collection
//       DocumentSnapshot doc =
//           await FirebaseFirestore.instance
//               .collection('influencers')
//               .doc(widget.application.influencerId)
//               .get();

//       if (doc.exists) {
//         print('Found in influencers collection: ${doc.data()}');
//         final rawData = doc.data() as Map<String, dynamic>;

//         // Transform the data to flat structure for easier access
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );

//         setState(() {
//           influencerData = transformedData;
//           isLoading = false;
//         });
//         _animationController.forward();
//         return;
//       }

//       // If not found, try 'users' collection
//       doc =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(widget.application.influencerId)
//               .get();

//       if (doc.exists) {
//         print('Found in users collection: ${doc.data()}');
//         final rawData = doc.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );

//         setState(() {
//           influencerData = transformedData;
//           isLoading = false;
//         });
//         _animationController.forward();
//         return;
//       }

//       // Try querying by email in influencers collection
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance
//               .collection('influencers')
//               .where('email', isEqualTo: widget.application.influencerEmail)
//               .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         print('Found by email query: ${querySnapshot.docs.first.data()}');
//         final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );

//         setState(() {
//           influencerData = transformedData;
//           isLoading = false;
//         });
//         _animationController.forward();
//         return;
//       }

//       // Try users collection by email
//       querySnapshot =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .where('email', isEqualTo: widget.application.influencerEmail)
//               .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         print('Found in users by email: ${querySnapshot.docs.first.data()}');
//         final rawData = querySnapshot.docs.first.data() as Map<String, dynamic>;
//         Map<String, dynamic> transformedData = _transformInfluencerData(
//           rawData,
//         );

//         setState(() {
//           influencerData = transformedData;
//           isLoading = false;
//         });
//         _animationController.forward();
//         return;
//       }

//       print('No influencer data found in any collection');
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading influencer details: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Transform the nested InfluencerProfile data to flat structure
//   Map<String, dynamic> _transformInfluencerData(Map<String, dynamic> rawData) {
//     Map<String, dynamic> transformed = Map.from(rawData);

//     // Extract social media data and calculate totals
//     if (rawData['socialMediaAccounts'] != null) {
//       List<dynamic> socialAccounts = rawData['socialMediaAccounts'];
//       int totalFollowers = 0;
//       double totalEngagement = 0.0;
//       int accountsWithEngagement = 0;

//       for (var account in socialAccounts) {
//         String platform = account['platform']?.toLowerCase() ?? '';

//         // Add follower counts
//         if (account['followerCount'] != null) {
//           totalFollowers += (account['followerCount'] as int);
//         }

//         // Add engagement rates
//         if (account['engagementRate'] != null) {
//           totalEngagement += (account['engagementRate'] as double);
//           accountsWithEngagement++;
//         }

//         // Extract platform-specific data
//         switch (platform) {
//           case 'instagram':
//             transformed['instagram'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['instagramFollowers'] = account['followerCount'];
//             transformed['instagramEngagement'] = account['engagementRate'];
//             break;
//           case 'youtube':
//             transformed['youtube'] =
//                 account['username'] ?? account['channelLink'];
//             transformed['youtubeFollowers'] = account['followerCount'];
//             transformed['youtubeViews'] = account['avgViews'];
//             break;
//           case 'tiktok':
//             transformed['tiktok'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['tiktokFollowers'] = account['followerCount'];
//             break;
//           case 'twitter':
//           case 'twitter/x':
//             transformed['twitter'] =
//                 account['username'] ?? account['profileUrl'];
//             transformed['twitterFollowers'] = account['followerCount'];
//             break;
//           case 'facebook':
//             transformed['facebook'] =
//                 account['username'] ?? account['profileUrl'];
//             break;
//           case 'linkedin':
//             transformed['linkedin'] =
//                 account['username'] ?? account['profileUrl'];
//             break;
//         }
//       }

//       // Set calculated totals
//       transformed['followers'] = totalFollowers;
//       transformed['engagement'] =
//           accountsWithEngagement > 0
//               ? (totalEngagement / accountsWithEngagement).round()
//               : 0;
//     }

//     // Extract performance metrics
//     if (rawData['performanceMetrics'] != null) {
//       Map<String, dynamic> metrics = rawData['performanceMetrics'];
//       transformed['followers'] =
//           metrics['totalFollowers'] ?? transformed['followers'] ?? 0;
//       transformed['engagement'] =
//           metrics['averageEngagementRate']?.round() ??
//           transformed['engagement'] ??
//           0;
//       transformed['avgViews'] = metrics['averageViews'];
//       transformed['pastCampaigns'] = metrics['pastCampaigns'];
//     }

//     // Extract professional info
//     if (rawData['professionalInfo'] != null) {
//       Map<String, dynamic> professional = rawData['professionalInfo'];

//       if (professional['rateCard'] != null) {
//         Map<String, dynamic> rateCard = professional['rateCard'];
//         transformed['postRate'] = rateCard['postRate'];
//         transformed['storyRate'] = rateCard['storyRate'];
//         transformed['videoRate'] = rateCard['videoRate'];
//         transformed['reelRate'] = rateCard['reelRate'];
//       }

//       transformed['pastCollaborationBrands'] =
//           professional['pastCollaborationBrands'];
//       transformed['brandsWorkedWith'] =
//           professional['pastCollaborationBrands']?.length ?? 0;
//     }

//     // Extract additional info
//     if (rawData['additionalInfo'] != null) {
//       Map<String, dynamic> additional = rawData['additionalInfo'];
//       transformed['gstNumber'] = additional['gstNumber'];
//       transformed['panNumber'] = additional['panNumber'];
//       transformed['paymentMethod'] = additional['paymentMethod'];
//     }

//     // Flatten basic fields
//     transformed['fullName'] = rawData['fullName'];
//     transformed['phone'] = rawData['phoneNumber'];
//     transformed['location'] =
//         '${rawData['city'] ?? ''}, ${rawData['country'] ?? ''}'
//             .trim()
//             .replaceAll(RegExp(r'^,|,$'), '');
//     transformed['category'] =
//         rawData['categories']?.isNotEmpty == true
//             ? rawData['categories'][0]
//             : 'General';
//     transformed['categories'] = rawData['categories'];
//     transformed['language'] =
//         rawData['languagesSpoken']?.isNotEmpty == true
//             ? rawData['languagesSpoken'].join(', ')
//             : null;
//     transformed['skills'] =
//         rawData['categories']; // Use categories as skills for now
//     transformed['interests'] =
//         rawData['categories']; // Use categories as interests for now

//     // Add some default metrics if missing
//     transformed['posts'] = transformed['posts'] ?? 50; // Default value
//     transformed['reach'] =
//         transformed['reach'] ??
//         (transformed['followers'] * 2); // Estimate reach
//     transformed['avgLikes'] =
//         transformed['avgLikes'] ??
//         ((transformed['followers'] * (transformed['engagement'] ?? 3)) / 100)
//             .round();
//     transformed['avgComments'] =
//         transformed['avgComments'] ?? (transformed['avgLikes'] / 10).round();
//     transformed['avgShares'] =
//         transformed['avgShares'] ?? (transformed['avgLikes'] / 20).round();
//     transformed['postFrequency'] = transformed['postFrequency'] ?? 'Daily';
//     transformed['responseRate'] = transformed['responseRate'] ?? 95;

//     // Audience analytics (estimated based on category and location)
//     transformed['audienceAge'] = _getAudienceAgeByCategory(
//       transformed['category'],
//     );
//     transformed['audienceGender'] = _getAudienceGenderByCategory(
//       transformed['category'],
//     );
//     transformed['audienceLocation'] = transformed['location'];
//     transformed['audienceInterests'] = transformed['category'];

//     // Collaboration metrics
//     transformed['totalCollaborations'] =
//         transformed['totalCollaborations'] ?? 5;
//     transformed['completedProjects'] = transformed['completedProjects'] ?? 4;
//     transformed['avgRating'] = transformed['avgRating'] ?? 4.5;

//     print('Transformed data: $transformed');
//     return transformed;
//   }

//   String _getAudienceAgeByCategory(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'gaming':
//       case 'tech':
//         return '18-25';
//       case 'fashion':
//       case 'beauty':
//         return '20-30';
//       case 'fitness':
//       case 'health':
//         return '25-35';
//       case 'business':
//       case 'education':
//         return '25-40';
//       default:
//         return '18-35';
//     }
//   }

//   String _getAudienceGenderByCategory(String? category) {
//     switch (category?.toLowerCase()) {
//       case 'fashion':
//       case 'beauty':
//         return '70% Female, 30% Male';
//       case 'gaming':
//       case 'tech':
//         return '65% Male, 35% Female';
//       case 'fitness':
//       case 'health':
//         return '55% Female, 45% Male';
//       default:
//         return '50% Female, 50% Male';
//     }
//   }

//   Future<void> _updateApplicationStatus(String status) async {
//     setState(() {
//       isUpdating = true;
//     });

//     try {
//       await FirebaseFirestore.instance
//           .collection('applications')
//           .doc(widget.application.id)
//           .update({'status': status, 'respondedAt': DateTime.now()});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Row(
//             children: [
//               Icon(
//                 status == 'accepted' ? Icons.check_circle : Icons.cancel,
//                 color: Colors.white,
//               ),
//               SizedBox(width: 8),
//               Text('Application $status successfully!'),
//             ],
//           ),
//           backgroundColor:
//               status == 'accepted' ? Color(0xFF22C55E) : Color(0xFFEF4444),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );

//       Navigator.pop(context, true);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating application'),
//           backgroundColor: Color(0xFFEF4444),
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       );
//     }

//     setState(() {
//       isUpdating = false;
//     });
//   }

//   Future<void> _launchUrl(String url) async {
//     if (!url.startsWith('http://') && !url.startsWith('https://')) {
//       url = 'https://$url';
//     }

//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF0FDF4),
//       body: isLoading ? _buildLoadingState() : _buildContent(),
//       bottomNavigationBar:
//           !isLoading && widget.application.status.toLowerCase() == 'pending'
//               ? _buildBottomActionBar()
//               : null,
//     );
//   }

//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             child: CircularProgressIndicator(
//               strokeWidth: 3,
//               valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
//             ),
//           ),
//           SizedBox(height: 24),
//           Text(
//             'Loading influencer profile...',
//             style: TextStyle(
//               color: Color(0xFF166534),
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return NestedScrollView(
//       headerSliverBuilder: (context, innerBoxIsScrolled) {
//         return [
//           _buildSliverAppBar(),
//           SliverPersistentHeader(
//             delegate: _SliverAppBarDelegate(_buildTabBar()),
//             pinned: true,
//           ),
//         ];
//       },
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildProfileTab(),
//           _buildSocialMediaTab(),
//           _buildMetricsTab(),
//           _buildApplicationTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildSliverAppBar() {
//     Color statusColor = _getStatusColor();

//     return SliverAppBar(
//       expandedHeight: 280.0,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: Colors.white,
//       foregroundColor: Color(0xFF166534),
//       flexibleSpace: FlexibleSpaceBar(
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
//             ),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(height: 40),
//               // Profile Avatar with Stats Overlay
//               Stack(
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0xFF22C55E).withOpacity(0.3),
//                           blurRadius: 20,
//                           offset: Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Text(
//                         widget.application.influencerName
//                             .substring(0, 1)
//                             .toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 48,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Follower count badge - Always show, even with 0 followers
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Color(0xFF22C55E), width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.people,
//                             size: 12,
//                             color: Color(0xFF22C55E),
//                           ),
//                           SizedBox(width: 2),
//                           Text(
//                             influencerData != null
//                                 ? _formatNumber(
//                                   influencerData!['followers'] ?? 0,
//                                 )
//                                 : '0',
//                             style: TextStyle(
//                               fontSize: 10,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF22C55E),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),
//               // Influencer Name Centered
//               Text(
//                 widget.application.influencerName,
//                 style: TextStyle(
//                   color: Color(0xFF166534),
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(height: 6),
//               // Status Badge Centered
//               Container(
//                 margin: EdgeInsets.only(top: 0),
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: _getStatusBgColor(),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: statusColor.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(_getStatusIcon(), size: 12, color: statusColor),
//                     SizedBox(width: 4),
//                     Text(
//                       _getStatusText(),
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w600,
//                         color: statusColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Quick Stats Row - Always show stats
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 24),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildQuickStat(
//                       'Posts',
//                       influencerData != null
//                           ? (influencerData!['posts'] ?? 0).toString()
//                           : '0',
//                       Icons.grid_on,
//                     ),
//                     _buildQuickStat(
//                       'Engagement',
//                       influencerData != null
//                           ? '${influencerData!['engagement'] ?? 0}%'
//                           : '0%',
//                       Icons.favorite,
//                     ),
//                     _buildQuickStat(
//                       'Category',
//                       influencerData != null
//                           ? (influencerData!['category'] ?? 'General')
//                           : 'General',
//                       Icons.category,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickStat(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.9),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Color(0xFF22C55E).withOpacity(0.3)),
//           ),
//           child: Icon(icon, size: 16, color: Color(0xFF22C55E)),
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF166534),
//           ),
//         ),
//         Text(label, style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
//       ],
//     );
//   }

//   Widget _buildTabBar() {
//     return Container(
//       color: Colors.white,
//       child: TabBar(
//         controller: _tabController,
//         labelColor: Color(0xFF22C55E),
//         unselectedLabelColor: Color(0xFF6B7280),
//         indicatorColor: Color(0xFF22C55E),
//         indicatorWeight: 3,
//         labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//         unselectedLabelStyle: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 14,
//         ),
//         tabs: [
//           Tab(icon: Icon(Icons.person, size: 20), text: 'Profile'),
//           Tab(icon: Icon(Icons.share, size: 20), text: 'Social'),
//           Tab(icon: Icon(Icons.analytics, size: 20), text: 'Metrics'),
//           Tab(icon: Icon(Icons.assignment, size: 20), text: 'Application'),
//         ],
//       ),
//     );
//   }

//   // Profile Tab - Personal Information
//   Widget _buildProfileTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildPersonalInfoCard(),
//           SizedBox(height: 20),
//           _buildContactInfoCard(),
//           SizedBox(height: 20),
//           _buildSkillsAndInterestsCard(),
//           SizedBox(height: 20),
//           _buildBioCard(),
//         ],
//       ),
//     );
//   }

//   // Social Media Tab
//   Widget _buildSocialMediaTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSocialPlatformsCard(),
//           SizedBox(height: 20),
//           _buildContentTypesCard(),
//           SizedBox(height: 20),
//           _buildCollaborationHistoryCard(),
//         ],
//       ),
//     );
//   }

//   // Metrics Tab
//   Widget _buildMetricsTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildMetricsOverviewCard(),
//           SizedBox(height: 20),
//           _buildAudienceAnalyticsCard(),
//           SizedBox(height: 20),
//           _buildPerformanceMetricsCard(),
//         ],
//       ),
//     );
//   }

//   // Application Tab
//   Widget _buildApplicationTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildApplicationDetailsCard(),
//           SizedBox(height: 20),
//           if (widget.application.message != null &&
//               widget.application.message!.isNotEmpty)
//             _buildMessageCard(),
//         ],
//       ),
//     );
//   }

//   Widget _buildPersonalInfoCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Personal Information',
//             Icons.person,
//             Color(0xFF22C55E),
//           ),
//           SizedBox(height: 20),
//           _buildInfoGrid([
//             if (influencerData!['fullName'] != null)
//               _InfoItem('Full Name', influencerData!['fullName'], Icons.badge),
//             if (influencerData!['age'] != null)
//               _InfoItem('Age', influencerData!['age'].toString(), Icons.cake),
//             if (influencerData!['gender'] != null)
//               _InfoItem('Gender', influencerData!['gender'], Icons.wc),
//             if (influencerData!['location'] != null)
//               _InfoItem(
//                 'Location',
//                 influencerData!['location'],
//                 Icons.location_on,
//               ),
//             if (influencerData!['language'] != null)
//               _InfoItem(
//                 'Language',
//                 influencerData!['language'],
//                 Icons.language,
//               ),
//             if (influencerData!['education'] != null)
//               _InfoItem(
//                 'Education',
//                 influencerData!['education'],
//                 Icons.school,
//               ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactInfoCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Contact Information',
//             Icons.contact_mail,
//             Color(0xFF16A34A),
//           ),
//           SizedBox(height: 20),
//           _buildContactItem(
//             'Email',
//             widget.application.influencerEmail,
//             Icons.email,
//             isEmail: true,
//           ),
//           if (influencerData!['phone'] != null)
//             _buildContactItem('Phone', influencerData!['phone'], Icons.phone),
//           if (influencerData!['website'] != null)
//             _buildContactItem(
//               'Website',
//               influencerData!['website'],
//               Icons.web,
//               isUrl: true,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSkillsAndInterestsCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     List<String> skills = [];
//     List<String> interests = [];

//     if (influencerData!['skills'] != null) {
//       if (influencerData!['skills'] is List) {
//         skills = List<String>.from(influencerData!['skills']);
//       } else if (influencerData!['skills'] is String) {
//         skills =
//             influencerData!['skills'].split(',').map((s) => s.trim()).toList();
//       }
//     }

//     if (influencerData!['interests'] != null) {
//       if (influencerData!['interests'] is List) {
//         interests = List<String>.from(influencerData!['interests']);
//       } else if (influencerData!['interests'] is String) {
//         interests =
//             influencerData!['interests']
//                 .split(',')
//                 .map((s) => s.trim())
//                 .toList();
//       }
//     }

//     if (skills.isEmpty &&
//         interests.isEmpty &&
//         influencerData!['category'] == null) {
//       return SizedBox.shrink();
//     }

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Skills & Interests',
//             Icons.star,
//             Color(0xFF15803D),
//           ),
//           SizedBox(height: 20),

//           if (influencerData!['category'] != null) ...[
//             Text(
//               'Primary Category',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF166534),
//               ),
//             ),
//             SizedBox(height: 8),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Color(0xFF22C55E).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Color(0xFF22C55E).withOpacity(0.3)),
//               ),
//               child: Text(
//                 influencerData!['category'],
//                 style: TextStyle(
//                   color: Color(0xFF22C55E),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//           ],

//           if (skills.isNotEmpty) ...[
//             Text(
//               'Skills',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF166534),
//               ),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children:
//                   skills
//                       .map((skill) => _buildChip(skill, Color(0xFF10B981)))
//                       .toList(),
//             ),
//             SizedBox(height: 16),
//           ],

//           if (interests.isNotEmpty) ...[
//             Text(
//               'Interests',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF166534),
//               ),
//             ),
//             SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children:
//                   interests
//                       .map(
//                         (interest) => _buildChip(interest, Color(0xFF059669)),
//                       )
//                       .toList(),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildBioCard() {
//     if (influencerData == null || influencerData!['bio'] == null)
//       return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader('About', Icons.info, Color(0xFF047857)),
//           SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Color(0xFFF0FDF4),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFDCFCE7)),
//             ),
//             child: Text(
//               influencerData!['bio'],
//               style: TextStyle(
//                 fontSize: 16,
//                 height: 1.6,
//                 color: Color(0xFF374151),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialPlatformsCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     List<Map<String, dynamic>> socialPlatforms = [
//       if (influencerData!['instagram'] != null)
//         {
//           'name': 'Instagram',
//           'handle': influencerData!['instagram'],
//           'icon': Icons.camera_alt,
//           'color': Color(0xFFE4405F),
//         },
//       if (influencerData!['youtube'] != null)
//         {
//           'name': 'YouTube',
//           'handle': influencerData!['youtube'],
//           'icon': Icons.play_circle,
//           'color': Color(0xFFFF0000),
//         },
//       if (influencerData!['tiktok'] != null)
//         {
//           'name': 'TikTok',
//           'handle': influencerData!['tiktok'],
//           'icon': Icons.music_note,
//           'color': Color(0xFF000000),
//         },
//       if (influencerData!['twitter'] != null)
//         {
//           'name': 'Twitter',
//           'handle': influencerData!['twitter'],
//           'icon': Icons.alternate_email,
//           'color': Color(0xFF1DA1F2),
//         },
//       if (influencerData!['linkedin'] != null)
//         {
//           'name': 'LinkedIn',
//           'handle': influencerData!['linkedin'],
//           'icon': Icons.business,
//           'color': Color(0xFF0077B5),
//         },
//       if (influencerData!['facebook'] != null)
//         {
//           'name': 'Facebook',
//           'handle': influencerData!['facebook'],
//           'icon': Icons.facebook,
//           'color': Color(0xFF1877F2),
//         },
//     ];

//     if (socialPlatforms.isEmpty) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Social Media Platforms',
//             Icons.share,
//             Color(0xFF22C55E),
//           ),
//           SizedBox(height: 20),
//           ...socialPlatforms.map(
//             (platform) => _buildSocialPlatformItem(platform),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSocialPlatformItem(Map<String, dynamic> platform) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFFF0FDF4),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: platform['color'].withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(platform['icon'], color: platform['color'], size: 20),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   platform['name'],
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF166534),
//                   ),
//                 ),
//                 Text(
//                   platform['handle'],
//                   style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             onPressed: () => _launchUrl(platform['handle']),
//             icon: Icon(Icons.open_in_new, color: Color(0xFF22C55E), size: 20),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContentTypesCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     List<String> contentTypes = [];
//     if (influencerData!['contentTypes'] != null) {
//       if (influencerData!['contentTypes'] is List) {
//         contentTypes = List<String>.from(influencerData!['contentTypes']);
//       } else if (influencerData!['contentTypes'] is String) {
//         contentTypes =
//             influencerData!['contentTypes']
//                 .split(',')
//                 .map((s) => s.trim())
//                 .toList();
//       }
//     }

//     if (contentTypes.isEmpty) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Content Types',
//             Icons.video_library,
//             Color(0xFF16A34A),
//           ),
//           SizedBox(height: 20),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children:
//                 contentTypes
//                     .map((type) => _buildChip(type, Color(0xFF22C55E)))
//                     .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCollaborationHistoryCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Collaboration Experience',
//             Icons.handshake,
//             Color(0xFF15803D),
//           ),
//           SizedBox(height: 20),
//           _buildInfoGrid([
//             if (influencerData!['totalCollaborations'] != null)
//               _InfoItem(
//                 'Total Collaborations',
//                 influencerData!['totalCollaborations'].toString(),
//                 Icons.work,
//               ),
//             if (influencerData!['brandsWorkedWith'] != null)
//               _InfoItem(
//                 'Brands Worked With',
//                 influencerData!['brandsWorkedWith'].toString(),
//                 Icons.business,
//               ),
//             if (influencerData!['avgRating'] != null)
//               _InfoItem(
//                 'Average Rating',
//                 '${influencerData!['avgRating']}/5',
//                 Icons.star,
//               ),
//             if (influencerData!['completedProjects'] != null)
//               _InfoItem(
//                 'Completed Projects',
//                 influencerData!['completedProjects'].toString(),
//                 Icons.check_circle,
//               ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildMetricsOverviewCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Performance Metrics',
//             Icons.analytics,
//             Color(0xFF22C55E),
//           ),
//           SizedBox(height: 20),
//           Container(
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Color(0xFFF0FDF4),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 if (influencerData!['followers'] != null)
//                   _buildMetricItem(
//                     'Followers',
//                     _formatNumber(influencerData!['followers']),
//                     Icons.people,
//                     Color(0xFF22C55E),
//                   ),
//                 if (influencerData!['engagement'] != null)
//                   _buildMetricItem(
//                     'Engagement',
//                     '${influencerData!['engagement']}%',
//                     Icons.favorite,
//                     Color(0xFF16A34A),
//                   ),
//                 if (influencerData!['reach'] != null)
//                   _buildMetricItem(
//                     'Reach',
//                     _formatNumber(influencerData!['reach']),
//                     Icons.visibility,
//                     Color(0xFF15803D),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAudienceAnalyticsCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Audience Analytics',
//             Icons.groups,
//             Color(0xFF16A34A),
//           ),
//           SizedBox(height: 20),
//           _buildInfoGrid([
//             if (influencerData!['audienceAge'] != null)
//               _InfoItem(
//                 'Primary Age Group',
//                 influencerData!['audienceAge'],
//                 Icons.people,
//               ),
//             if (influencerData!['audienceGender'] != null)
//               _InfoItem(
//                 'Audience Gender',
//                 influencerData!['audienceGender'],
//                 Icons.wc,
//               ),
//             if (influencerData!['audienceLocation'] != null)
//               _InfoItem(
//                 'Top Location',
//                 influencerData!['audienceLocation'],
//                 Icons.location_on,
//               ),
//             if (influencerData!['audienceInterests'] != null)
//               _InfoItem(
//                 'Top Interests',
//                 influencerData!['audienceInterests'],
//                 Icons.interests,
//               ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceMetricsCard() {
//     if (influencerData == null) return SizedBox.shrink();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Recent Performance',
//             Icons.trending_up,
//             Color(0xFF15803D),
//           ),
//           SizedBox(height: 20),
//           _buildInfoGrid([
//             if (influencerData!['avgLikes'] != null)
//               _InfoItem(
//                 'Avg. Likes',
//                 _formatNumber(influencerData!['avgLikes']),
//                 Icons.thumb_up,
//               ),
//             if (influencerData!['avgComments'] != null)
//               _InfoItem(
//                 'Avg. Comments',
//                 _formatNumber(influencerData!['avgComments']),
//                 Icons.comment,
//               ),
//             if (influencerData!['avgShares'] != null)
//               _InfoItem(
//                 'Avg. Shares',
//                 _formatNumber(influencerData!['avgShares']),
//                 Icons.share,
//               ),
//             if (influencerData!['avgViews'] != null)
//               _InfoItem(
//                 'Avg. Views',
//                 _formatNumber(influencerData!['avgViews']),
//                 Icons.visibility,
//               ),
//             if (influencerData!['postFrequency'] != null)
//               _InfoItem(
//                 'Post Frequency',
//                 influencerData!['postFrequency'],
//                 Icons.schedule,
//               ),
//             if (influencerData!['responseRate'] != null)
//               _InfoItem(
//                 'Response Rate',
//                 '${influencerData!['responseRate']}%',
//                 Icons.reply,
//               ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildApplicationDetailsCard() {
//     Color statusColor = _getStatusColor();
//     Color statusBgColor = _getStatusBgColor();

//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Application Details',
//             Icons.assignment,
//             Color(0xFF22C55E),
//           ),
//           SizedBox(height: 20),

//           // Campaign Title
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Color(0xFFF0FDF4),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFDCFCE7)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Campaign',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   widget.application.campaignTitle,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF166534),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           SizedBox(height: 16),

//           // Application Info
//           _buildDetailRow('Application ID', widget.application.id ?? 'N/A'),
//           _buildDetailRow(
//             'Applied On',
//             _formatDateTime(widget.application.appliedAt),
//           ),
//           if (widget.application.respondedAt != null)
//             _buildDetailRow(
//               'Responded On',
//               _formatDateTime(widget.application.respondedAt!),
//             ),

//           SizedBox(height: 16),

//           // Status
//           Row(
//             children: [
//               Text(
//                 'Status: ',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF166534),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: statusBgColor,
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: statusColor.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(_getStatusIcon(), size: 18, color: statusColor),
//                     SizedBox(width: 6),
//                     Text(
//                       _getStatusText(),
//                       style: TextStyle(
//                         color: statusColor,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageCard() {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF22C55E).withOpacity(0.08),
//             blurRadius: 24,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionHeader(
//             'Application Message',
//             Icons.message,
//             Color(0xFF16A34A),
//           ),
//           SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Color(0xFFF0FDF4),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Color(0xFFDCFCE7)),
//             ),
//             child: Text(
//               widget.application.message!,
//               style: TextStyle(
//                 fontSize: 16,
//                 height: 1.6,
//                 color: Color(0xFF374151),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomActionBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.95),
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed:
//                     isUpdating
//                         ? null
//                         : () => _updateApplicationStatus('rejected'),
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Color(0xFFFEE2E2),
//                   foregroundColor: Color(0xFFB91C1C),
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child:
//                     isUpdating
//                         ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFFB91C1C),
//                             ),
//                           ),
//                         )
//                         : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.close_rounded, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               'Reject',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed:
//                     isUpdating
//                         ? null
//                         : () => _updateApplicationStatus('accepted'),
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: Color(0xFFDCFCE7),
//                   foregroundColor: Color(0xFF166534),
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//                 child:
//                     isUpdating
//                         ? SizedBox(
//                           width: 20,
//                           height: 20,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(
//                               Color(0xFF166534),
//                             ),
//                           ),
//                         )
//                         : Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.check_rounded, size: 20),
//                             SizedBox(width: 8),
//                             Text(
//                               'Accept',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Widgets
//   Widget _buildSectionHeader(String title, IconData icon, Color color) {
//     return Row(
//       children: [
//         Container(
//           padding: EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, color: color, size: 20),
//         ),
//         SizedBox(width: 12),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF166534),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoGrid(List<_InfoItem> items) {
//     return Column(
//       children: [
//         for (int i = 0; i < items.length; i += 2)
//           Padding(
//             padding: EdgeInsets.only(bottom: 12),
//             child: Row(
//               children: [
//                 Expanded(child: _buildInfoCard(items[i])),
//                 if (i + 1 < items.length) ...[
//                   SizedBox(width: 12),
//                   Expanded(child: _buildInfoCard(items[i + 1])),
//                 ] else
//                   Expanded(child: SizedBox()),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildInfoCard(_InfoItem item) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xFFF0FDF4),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(item.icon, size: 16, color: Color(0xFF22C55E)),
//               SizedBox(width: 6),
//               Expanded(
//                 child: Text(
//                   item.label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4),
//           Text(
//             item.value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF166534),
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContactItem(
//     String label,
//     String value,
//     IconData icon, {
//     bool isEmail = false,
//     bool isUrl = false,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Color(0xFFF0FDF4),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Color(0xFFDCFCE7)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Color(0xFF22C55E).withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(icon, color: Color(0xFF22C55E), size: 20),
//           ),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: Color(0xFF6B7280),
//                   ),
//                 ),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF166534),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isEmail || isUrl)
//             IconButton(
//               onPressed: () {
//                 if (isEmail) {
//                   _launchUrl('mailto:$value');
//                 } else if (isUrl) {
//                   _launchUrl(value);
//                 }
//               },
//               icon: Icon(
//                 isEmail ? Icons.email : Icons.open_in_new,
//                 color: Color(0xFF22C55E),
//                 size: 20,
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChip(String text, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildMetricItem(
//     String label,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 24),
//           SizedBox(height: 8),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF6B7280),
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF6B7280),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF166534),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Status helper methods (same as before)
//   Color _getStatusColor() {
//     switch (widget.application.status.toLowerCase()) {
//       case 'pending':
//         return Color(0xFFF59E0B);
//       case 'accepted':
//         return Color(0xFF10B981);
//       case 'rejected':
//         return Color(0xFFEF4444);
//       default:
//         return Color(0xFF6B7280);
//     }
//   }

//   Color _getStatusBgColor() {
//     switch (widget.application.status.toLowerCase()) {
//       case 'pending':
//         return Color(0xFFFEF3C7);
//       case 'accepted':
//         return Color(0xFFD1FAE5);
//       case 'rejected':
//         return Color(0xFFFEE2E2);
//       default:
//         return Color(0xFFF3F4F6);
//     }
//   }

//   IconData _getStatusIcon() {
//     switch (widget.application.status.toLowerCase()) {
//       case 'pending':
//         return Icons.schedule_rounded;
//       case 'accepted':
//         return Icons.check_circle_rounded;
//       case 'rejected':
//         return Icons.cancel_rounded;
//       default:
//         return Icons.help_outline_rounded;
//     }
//   }

//   String _getStatusText() {
//     switch (widget.application.status.toLowerCase()) {
//       case 'pending':
//         return 'Pending Review';
//       case 'accepted':
//         return 'Accepted';
//       case 'rejected':
//         return 'Rejected';
//       default:
//         return widget.application.status;
//     }
//   }

//   String _formatDateTime(DateTime dateTime) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];
//     return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//   }

//   String _formatNumber(dynamic number) {
//     if (number == null) return '0';
//     int num = int.tryParse(number.toString()) ?? 0;
//     if (num >= 1000000) {
//       return '${(num / 1000000).toStringAsFixed(1)}M';
//     } else if (num >= 1000) {
//       return '${(num / 1000).toStringAsFixed(1)}K';
//     }
//     return num.toString();
//   }
// }

// // Custom sliver delegate for tab bar
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final Widget _tabBar;

//   _SliverAppBarDelegate(this._tabBar);

//   @override
//   double get minExtent => 60;
//   @override
//   double get maxExtent => 60;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(child: _tabBar);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }

// class _InfoItem {
//   final String label;
//   final String value;
//   final IconData icon;

//   _InfoItem(this.label, this.value, this.icon);
// }
import 'package:creatorcrew/Brand/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/InfluencerDetailProvider.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/MessageProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfluencerDetailScreen extends StatefulWidget {
  final ApplicationModel application;

  const InfluencerDetailScreen({Key? key, required this.application})
    : super(key: key);

  @override
  _InfluencerDetailScreenState createState() => _InfluencerDetailScreenState();
}

class _InfluencerDetailScreenState extends State<InfluencerDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late TabController _tabController;
  late InfluencerDetailProvider _provider;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _tabController = TabController(length: 4, vsync: this);

    _provider = InfluencerDetailProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider
          .loadInfluencerDetails(widget.application)
          .then((_) => _animationController.forward());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _provider.dispose();
    super.dispose();
  }

  Future<void> _updateApplicationStatus(String status) async {
    if (status == 'accepted') {
      await _handleAcceptApplication();
    } else {
      await _handleRejectApplication();
    }
  }

  Future<void> _handleAcceptApplication() async {
    final messageProvider = context.read<MessageProvider>();
    final brandProvider = context.read<BrandInfoProvider>();

    final campaignTitle = widget.application.campaignTitle ?? 'Campaign';
    final brandName = brandProvider.brandInfo?.brandName ?? 'Your Brand';

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF22C55E)),
                SizedBox(height: 16),
                Text(
                  'Processing acceptance...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Updating status and sending message',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
    );

    try {
      // Update application status
      final success = await _provider.updateApplicationStatus(
        widget.application.id ?? '',
        'accepted',
      );

      if (success) {
        // Send acceptance message to influencer
        final messageSuccess = await messageProvider.sendAcceptanceMessage(
          application: widget.application,
          brandName: brandName,
          campaignTitle: campaignTitle,
        );

        Navigator.pop(context); // Close loading dialog

        if (messageSuccess) {
          // Show success dialog
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFF22C55E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xFF22C55E),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Application Accepted!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSuccessItem(
                        '✅',
                        'Application status updated to accepted',
                      ),
                      SizedBox(height: 8),
                      _buildSuccessItem(
                        '📧',
                        'Acceptance message sent to ${widget.application.influencerName}',
                      ),
                      SizedBox(height: 8),
                      _buildSuccessItem(
                        '💬',
                        'Chat room created for collaboration',
                      ),
                      SizedBox(height: 8),
                      _buildSuccessItem(
                        '📅',
                        'Meeting request included in message',
                      ),
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color(0xFF22C55E).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF166534),
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Next Steps',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'The influencer has been notified and asked for their meeting availability. You can continue the conversation in the Chat section to coordinate details.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF166534),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(
                          context,
                          true,
                        ); // Go back to applications list
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context, true); // Go back
                        // Navigate to chat screen - you can implement this based on your navigation
                        _navigateToChat();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF22C55E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat, size: 16),
                          SizedBox(width: 4),
                          Text('Open Chat'),
                        ],
                      ),
                    ),
                  ],
                ),
          );
        } else {
          _showErrorMessage('Failed to send acceptance message');
        }
      } else {
        Navigator.pop(context); // Close loading dialog
        _showErrorMessage('Failed to update application status');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorMessage('Error: $e');
    }
  }

  Widget _buildSuccessItem(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: TextStyle(fontSize: 16)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  void _navigateToChat() {
    // Implement navigation to chat screen
    // You can navigate to your chat screen here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat feature will be implemented'),
        backgroundColor: Color(0xFF22C55E),
      ),
    );
  }

  Future<void> _handleRejectApplication() async {
    // Show confirmation dialog first
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text('Confirm Rejection'),
              ],
            ),
            content: Text(
              'Are you sure you want to reject ${widget.application.influencerName}\'s application for "${widget.application.campaignTitle}"?\n\nThis action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                ),
                child: Text('Reject'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final success = await _provider.updateApplicationStatus(
        widget.application.id ?? '',
        'rejected',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.cancel, color: Colors.white),
                SizedBox(width: 8),
                Text('Application rejected successfully'),
              ],
            ),
            backgroundColor: Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showErrorMessage('Failed to reject application');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _provider),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: Consumer2<InfluencerDetailProvider, MessageProvider>(
        builder: (context, influencerProvider, messageProvider, child) {
          return Scaffold(
            backgroundColor: Color(0xFFF0FDF4),
            body:
                influencerProvider.isLoading
                    ? _buildLoadingState()
                    : _buildContent(influencerProvider),
            bottomNavigationBar:
                !influencerProvider.isLoading &&
                        widget.application.status.toLowerCase() == 'pending'
                    ? _buildBottomActionBar(influencerProvider, messageProvider)
                    : null,
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF22C55E).withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Loading influencer profile...',
              style: TextStyle(
                color: Color(0xFF166534),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Please wait while we fetch the details',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(InfluencerDetailProvider provider) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar(provider),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(_buildTabBar()),
            pinned: true,
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(provider),
          _buildSocialMediaTab(provider),
          _buildMetricsTab(provider),
          _buildApplicationTab(provider),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(InfluencerDetailProvider provider) {
    Color statusColor = _getStatusColor();

    return SliverAppBar(
      expandedHeight: 280.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF166534),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.arrow_back, color: Color(0xFF166534)),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              // Profile Avatar with Stats Overlay
              Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF22C55E).withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.application.influencerName
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 48,
                        ),
                      ),
                    ),
                  ),
                  // Follower count badge
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xFF22C55E), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            size: 12,
                            color: Color(0xFF22C55E),
                          ),
                          SizedBox(width: 2),
                          Text(
                            provider.influencerData != null
                                ? provider.formatNumber(
                                  provider.influencerData!['followers'] ?? 0,
                                )
                                : '0',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Influencer Name Centered
              Text(
                widget.application.influencerName,
                style: TextStyle(
                  color: Color(0xFF166534),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 6),
              // Status Badge Centered
              Container(
                margin: EdgeInsets.only(top: 0),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getStatusIcon(), size: 12, color: statusColor),
                    SizedBox(width: 4),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Quick Stats Row
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickStat(
                      'Posts',
                      provider.influencerData != null
                          ? (provider.influencerData!['posts'] ?? 0).toString()
                          : '0',
                      Icons.grid_on,
                    ),
                    _buildQuickStat(
                      'Engagement',
                      provider.influencerData != null
                          ? '${provider.influencerData!['engagement'] ?? 0}%'
                          : '0%',
                      Icons.favorite,
                    ),
                    _buildQuickStat(
                      'Category',
                      provider.influencerData != null
                          ? (provider.influencerData!['category'] ?? 'General')
                          : 'General',
                      Icons.category,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(
    InfluencerDetailProvider provider,
    MessageProvider messageProvider,
  ) {
    final isLoading = provider.isUpdating || messageProvider.isSending;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () => _updateApplicationStatus('rejected'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color(0xFFFEE2E2),
                  foregroundColor: Color(0xFFB91C1C),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFB91C1C),
                            ),
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.close_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : () => _updateApplicationStatus('accepted'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    isLoading
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Processing...'),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Accept & Send Message',
                              style: TextStyle(
                                fontSize: 15,
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
    );
  }

  // Helper methods
  Color _getStatusColor() {
    switch (widget.application.status.toLowerCase()) {
      case 'pending':
        return Color(0xFFF59E0B);
      case 'accepted':
        return Color(0xFF10B981);
      case 'rejected':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  Color _getStatusBgColor() {
    switch (widget.application.status.toLowerCase()) {
      case 'pending':
        return Color(0xFFFEF3C7);
      case 'accepted':
        return Color(0xFFD1FAE5);
      case 'rejected':
        return Color(0xFFFEE2E2);
      default:
        return Color(0xFFF3F4F6);
    }
  }

  IconData _getStatusIcon() {
    switch (widget.application.status.toLowerCase()) {
      case 'pending':
        return Icons.schedule_rounded;
      case 'accepted':
        return Icons.check_circle_rounded;
      case 'rejected':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _getStatusText() {
    switch (widget.application.status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      default:
        return widget.application.status;
    }
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFF22C55E).withOpacity(0.3)),
          ),
          child: Icon(icon, size: 16, color: Color(0xFF22C55E)),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF166534),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Color(0xFF22C55E),
        unselectedLabelColor: Color(0xFF6B7280),
        indicatorColor: Color(0xFF22C55E),
        indicatorWeight: 3,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: [
          Tab(icon: Icon(Icons.person, size: 20), text: 'Profile'),
          Tab(icon: Icon(Icons.share, size: 20), text: 'Social'),
          Tab(icon: Icon(Icons.analytics, size: 20), text: 'Metrics'),
          Tab(icon: Icon(Icons.assignment, size: 20), text: 'Application'),
        ],
      ),
    );
  }

  // Tab content methods
  Widget _buildProfileTab(InfluencerDetailProvider provider) {
    if (provider.influencerData == null) {
      return Center(
        child: Text(
          'No profile data available',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    final data = provider.influencerData!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildBioCard(data),
          SizedBox(height: 16),
          _buildContactCard(data),
          SizedBox(height: 16),
          _buildContentTypesCard(data),
        ],
      ),
    );
  }

  Widget _buildBioCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
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
              Icon(Icons.person, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Profile Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailRow('Full Name', data['fullName'] ?? 'Not specified'),
          _buildDetailRow('Location', data['location'] ?? 'Not specified'),
          _buildDetailRow('Category', data['category'] ?? 'General'),
          if (data['language'] != null)
            _buildDetailRow('Languages', data['language']),
          _buildDetailRow('Email', widget.application.influencerEmail),
          if (data['phone'] != null) _buildDetailRow('Phone', data['phone']),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
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
              Icon(Icons.contact_mail, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Contact Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildContactItem(
            'Email',
            widget.application.influencerEmail,
            Icons.email,
            isEmail: true,
          ),
          if (data['phone'] != null)
            _buildContactItem('Phone', data['phone'], Icons.phone),
          if (data['instagram'] != null)
            _buildContactItem(
              'Instagram',
              data['instagram'],
              Icons.camera_alt,
              isUrl: true,
            ),
          if (data['youtube'] != null)
            _buildContactItem(
              'YouTube',
              data['youtube'],
              Icons.play_circle_fill,
              isUrl: true,
            ),
        ],
      ),
    );
  }

  Widget _buildContentTypesCard(Map<String, dynamic> data) {
    final categories = data['categories'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
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
              Icon(Icons.category, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Content Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (categories.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  categories
                      .map(
                        (category) =>
                            _buildChip(category.toString(), Color(0xFF22C55E)),
                      )
                      .toList(),
            )
          else
            Text(
              'No categories specified',
              style: TextStyle(color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialMediaTab(InfluencerDetailProvider provider) {
    return Center(child: Text('Social Media Content'));
  }

  Widget _buildMetricsTab(InfluencerDetailProvider provider) {
    return Center(child: Text('Metrics Content'));
  }

  Widget _buildApplicationTab(InfluencerDetailProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildApplicationDetailsCard(),
          SizedBox(height: 16),
          _buildMessageCard(),
        ],
      ),
    );
  }

  Widget _buildApplicationDetailsCard() {
    Color statusColor = _getStatusColor();
    Color statusBgColor = _getStatusBgColor();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
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
              Icon(Icons.assignment, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Application Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDetailRow(
            'Campaign',
            widget.application.campaignTitle ?? 'N/A',
          ),
          _buildDetailRow('Influencer', widget.application.influencerName),
          _buildDetailRow(
            'Applied On',
            _formatDateTime(widget.application.appliedAt),
          ),
          Row(
            children: [
              Text(
                'Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getStatusIcon(), size: 12, color: statusColor),
                    SizedBox(width: 4),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
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
              Icon(Icons.message, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Application Message',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFDCFCE7)),
            ),
            child: Text(
              widget.application.message ?? 'No message provided',
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Color(0xFF6B7280))),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    String label,
    String value,
    IconData icon, {
    bool isEmail = false,
    bool isUrl = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFDCFCE7)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF22C55E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF22C55E), size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Color(0xFF166534)),
                ),
              ],
            ),
          ),
          if (isEmail || isUrl)
            IconButton(
              onPressed: () => _launchUrl(isEmail ? 'mailto:$value' : value),
              icon: Icon(
                isEmail ? Icons.mail_outline : Icons.open_in_new,
                color: Color(0xFF22C55E),
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!url.startsWith('http://') &&
        !url.startsWith('https://') &&
        !url.startsWith('mailto:')) {
      url = 'https://$url';
    }

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Custom sliver delegate for tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 60;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
