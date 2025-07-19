// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/Brand/Dashboard/Screens/influencersDetailScreen.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BrandApplicationsScreen extends StatefulWidget {
//   @override
//   _BrandApplicationsScreenState createState() =>
//       _BrandApplicationsScreenState();
// }

// class _BrandApplicationsScreenState extends State<BrandApplicationsScreen> {
//   List<ApplicationModel> _applications = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadApplications();
//   }

//   Future<void> _loadApplications() async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) return;

//       final snapshot =
//           await FirebaseFirestore.instance
//               .collection('applications')
//               .where('brandId', isEqualTo: currentUser.uid)
//               .get();

//       List<ApplicationModel> applications = [];
//       for (var doc in snapshot.docs) {
//         try {
//           applications.add(ApplicationModel.fromJson(doc.data()));
//         } catch (e) {
//           print('Error parsing application: $e');
//         }
//       }

//       setState(() {
//         _applications = applications;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading applications: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Campaign Applications'),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 1,
//       ),
//       backgroundColor: Colors.grey[50],
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : _applications.isEmpty
//               ? _buildEmptyState()
//               : _buildApplicationsList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
//           SizedBox(height: 16),
//           Text(
//             'No Applications Yet',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Applications for your campaigns will appear here',
//             style: TextStyle(color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildApplicationsList() {
//     return RefreshIndicator(
//       onRefresh: _loadApplications,
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: _applications.length,
//         itemBuilder: (context, index) {
//           final application = _applications[index];
//           return _buildApplicationCard(application);
//         },
//       ),
//     );
//   }

//   Widget _buildApplicationCard(ApplicationModel application) {
//     Color statusColor;
//     IconData statusIcon;

//     switch (application.status.toLowerCase()) {
//       case 'pending':
//         statusColor = Colors.orange;
//         statusIcon = Icons.schedule;
//         break;
//       case 'accepted':
//         statusColor = Colors.green;
//         statusIcon = Icons.check_circle;
//         break;
//       case 'rejected':
//         statusColor = Colors.red;
//         statusIcon = Icons.cancel;
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusIcon = Icons.help_outline;
//     }

//     return Card(
//       margin: EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder:
//                   (context) => InfluencerDetailScreen(application: application),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header with status and date
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: statusColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(statusIcon, size: 14, color: statusColor),
//                         SizedBox(width: 4),
//                         Text(
//                           application.status.toUpperCase(),
//                           style: TextStyle(
//                             color: statusColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Spacer(),
//                   Text(
//                     _formatDate(application.appliedAt),
//                     style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 12),

//               // Campaign title
//               Text(
//                 application.campaignTitle,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8),

//               // Influencer info
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.blue,
//                     child: Text(
//                       application.influencerName.substring(0, 1).toUpperCase(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           application.influencerName,
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                           ),
//                         ),
//                         Text(
//                           application.influencerEmail,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.arrow_forward_ios,
//                     size: 16,
//                     color: Colors.grey[400],
//                   ),
//                 ],
//               ),

//               // Message preview if exists
//               if (application.message != null &&
//                   application.message!.isNotEmpty)
//                 Padding(
//                   padding: EdgeInsets.only(top: 12),
//                   child: Container(
//                     padding: EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       application.message!,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 14),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Dashboard/Screens/influencersDetailScreen.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BrandApplicationsScreen extends StatefulWidget {
  @override
  _BrandApplicationsScreenState createState() =>
      _BrandApplicationsScreenState();
}

class _BrandApplicationsScreenState extends State<BrandApplicationsScreen>
    with TickerProviderStateMixin {
  List<ApplicationModel> _applications = [];
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All';
  late AnimationController _animationController;

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Accepted',
    'Rejected',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _loadApplications();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          _error = 'User not authenticated';
          _isLoading = false;
        });
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance
              .collection('applications')
              .where('brandId', isEqualTo: currentUser.uid)
              .get();

      List<ApplicationModel> applications = [];
      for (var doc in snapshot.docs) {
        try {
          final data = doc.data();

          // Handle different timestamp formats
          if (data['appliedAt'] is Timestamp) {
            applications.add(ApplicationModel.fromJson(data));
          } else if (data['appliedAt'] is String) {
            data['appliedAt'] = Timestamp.fromDate(
              DateTime.parse(data['appliedAt']),
            );
            applications.add(ApplicationModel.fromJson(data));
          } else {
            data['appliedAt'] = Timestamp.now();
            applications.add(ApplicationModel.fromJson(data));
          }
        } catch (e) {
          print('Error parsing application ${doc.id}: $e');
        }
      }

      // Sort by most recent first
      applications.sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

      setState(() {
        _applications = applications;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      print('Error loading applications: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<ApplicationModel> get _filteredApplications {
    if (_selectedFilter == 'All') {
      return _applications;
    }
    return _applications
        .where(
          (app) => app.status.toLowerCase() == _selectedFilter.toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FDF4), // Very light green background
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF166534), // Dark green
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Campaign Applications',
          style: TextStyle(
            color: Color(0xFF166534),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFECFDF5), // Light green
                Color(0xFFF0FDF4), // Very light green
              ],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF22C55E), Color(0xFF16A34A)], // Green gradient
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF22C55E).withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadApplications,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Loading applications...',
                style: TextStyle(
                  color: Color(0xFF166534),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: Color(0xFFEF4444),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Unable to load applications',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF166534),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: TextStyle(color: Color(0xFF4B5563), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadApplications,
                icon: Icon(Icons.refresh_rounded),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_applications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildStatsHeader(),
        _buildFilterTabs(),
        _buildApplicationsList(),
      ],
    );
  }

  Widget _buildStatsHeader() {
    final totalApplications = _applications.length;
    final pendingCount =
        _applications
            .where((app) => app.status.toLowerCase() == 'pending')
            .length;
    final acceptedCount =
        _applications
            .where((app) => app.status.toLowerCase() == 'accepted')
            .length;
    final rejectedCount =
        _applications
            .where((app) => app.status.toLowerCase() == 'rejected')
            .length;

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFFDCFCE7), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: Color(0xFF22C55E),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Applications Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                'Total',
                totalApplications.toString(),
                Color(0xFF22C55E),
              ),
              _buildStatItem(
                'Pending',
                pendingCount.toString(),
                Color(0xFFF59E0B),
              ),
              _buildStatItem(
                'Accepted',
                acceptedCount.toString(),
                Color(0xFF10B981),
              ),
              _buildStatItem(
                'Rejected',
                rejectedCount.toString(),
                Color(0xFFEF4444),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children:
            _filterOptions.map((filter) {
              final isSelected = _selectedFilter == filter;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: filter != _filterOptions.last ? 8 : 0,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? LinearGradient(
                                colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                              )
                              : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected ? Color(0xFF22C55E) : Color(0xFFDCFCE7),
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Color(0xFF22C55E).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Text(
                      filter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Color(0xFF166534),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Color(0xFF22C55E).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 60,
                color: Color(0xFF22C55E),
              ),
            ),
            SizedBox(height: 32),
            Text(
              'No Applications Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF166534),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Applications for your campaigns will appear here',
                style: TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList() {
    final filteredApps = _filteredApplications;

    if (filteredApps.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Text(
            'No ${_selectedFilter.toLowerCase()} applications',
            style: TextStyle(color: Color(0xFF166534), fontSize: 16),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApplications,
      color: Color(0xFF22C55E),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20),
        itemCount: filteredApps.length,
        itemBuilder: (context, index) {
          final application = filteredApps[index];
          return _buildApplicationCard(application, index);
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationModel application, int index) {
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;
    String statusText;

    switch (application.status.toLowerCase()) {
      case 'pending':
        statusColor = Color(0xFFF59E0B);
        statusBgColor = Color(0xFFFEF3C7);
        statusIcon = Icons.schedule_rounded;
        statusText = 'Pending Review';
        break;
      case 'accepted':
        statusColor = Color(0xFF10B981);
        statusBgColor = Color(0xFFD1FAE5);
        statusIcon = Icons.check_circle_rounded;
        statusText = 'Accepted';
        break;
      case 'rejected':
        statusColor = Color(0xFFEF4444);
        statusBgColor = Color(0xFFFEE2E2);
        statusIcon = Icons.cancel_rounded;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Color(0xFF6B7280);
        statusBgColor = Color(0xFFF3F4F6);
        statusIcon = Icons.help_outline_rounded;
        statusText = application.status;
    }

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF22C55E).withOpacity(0.08),
                    blurRadius: 24,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Color(0xFFDCFCE7), width: 1),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => InfluencerDetailScreen(
                              application: application,
                            ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with Prominent Status
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: statusBgColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    statusIcon,
                                    size: 18,
                                    color: statusColor,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    statusText,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    size: 12,
                                    color: Color(0xFF22C55E),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    _formatDate(application.appliedAt),
                                    style: TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Campaign Title
                        Text(
                          application.campaignTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF166534),
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Influencer Info Section
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFFDCFCE7)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF22C55E),
                                      Color(0xFF16A34A),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    application.influencerName
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      application.influencerName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Color(0xFF166534),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      application.influencerEmail,
                                      style: TextStyle(
                                        color: Color(0xFF4B5563),
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Color(0xFF22C55E)),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Color(0xFF22C55E),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Message Preview
                        if (application.message != null &&
                            application.message!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFBBF7D0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.message_rounded,
                                        size: 16,
                                        color: Color(0xFF22C55E),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Application Message',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Color(0xFF22C55E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    application.message!,
                                    style: TextStyle(
                                      color: Color(0xFF166534),
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 12),

                        // Bottom Action Hint
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tap to view influencer details',
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF22C55E).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Color(0xFF22C55E).withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Color(0xFF22C55E),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
        );
      },
    );
  }

  String _formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }
}
