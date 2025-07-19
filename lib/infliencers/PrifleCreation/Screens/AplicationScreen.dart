// // import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// // import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';

// // class MyApplicationsScreen extends StatefulWidget {
// //   @override
// //   _MyApplicationsScreenState createState() => _MyApplicationsScreenState();
// // }

// // class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       Provider.of<ApplicationProvider>(
// //         context,
// //         listen: false,
// //       ).fetchMyApplications();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[50],
// //       appBar: AppBar(
// //         title: Text(
// //           'My Applications',
// //           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
// //         ),
// //         backgroundColor: Colors.white,
// //         elevation: 0,
// //         iconTheme: IconThemeData(color: Colors.black87),
// //       ),
// //       body: Consumer<ApplicationProvider>(
// //         builder: (context, applicationProvider, child) {
// //           if (applicationProvider.isLoading) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   CircularProgressIndicator(),
// //                   SizedBox(height: 16),
// //                   Text('Loading your applications...'),
// //                 ],
// //               ),
// //             );
// //           }

// //           return FutureBuilder<List<ApplicationModel>>(
// //             future: applicationProvider.fetchMyApplications(),
// //             builder: (context, snapshot) {
// //               if (snapshot.connectionState == ConnectionState.waiting) {
// //                 return Center(child: CircularProgressIndicator());
// //               }

// //               if (snapshot.hasError) {
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(Icons.error_outline, size: 60, color: Colors.red),
// //                       SizedBox(height: 16),
// //                       Text('Error loading applications'),
// //                       SizedBox(height: 8),
// //                       Text(
// //                         snapshot.error.toString(),
// //                         style: TextStyle(color: Colors.grey),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }

// //               final applications = snapshot.data ?? [];

// //               if (applications.isEmpty) {
// //                 return Center(
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       Icon(
// //                         Icons.assignment_outlined,
// //                         size: 80,
// //                         color: Colors.grey[400],
// //                       ),
// //                       SizedBox(height: 16),
// //                       Text(
// //                         'No Applications Yet',
// //                         style: TextStyle(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.w600,
// //                           color: Colors.grey[600],
// //                         ),
// //                       ),
// //                       SizedBox(height: 8),
// //                       Text(
// //                         'Apply to campaigns to see them here',
// //                         style: TextStyle(color: Colors.grey[500]),
// //                       ),
// //                       SizedBox(height: 20),
// //                       ElevatedButton(
// //                         onPressed: () => Navigator.pop(context),
// //                         child: Text('Browse Campaigns'),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: Colors.blue,
// //                           foregroundColor: Colors.white,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 );
// //               }

// //               return ListView.builder(
// //                 padding: EdgeInsets.all(16),
// //                 itemCount: applications.length,
// //                 itemBuilder: (context, index) {
// //                   final application = applications[index];
// //                   return _buildApplicationCard(application);
// //                 },
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildApplicationCard(ApplicationModel application) {
// //     Color statusColor;
// //     IconData statusIcon;
// //     String statusText;

// //     switch (application.status.toLowerCase()) {
// //       case 'pending':
// //         statusColor = Colors.orange;
// //         statusIcon = Icons.hourglass_empty;
// //         statusText = 'Pending';
// //         break;
// //       case 'accepted':
// //         statusColor = Colors.green;
// //         statusIcon = Icons.check_circle;
// //         statusText = 'Accepted';
// //         break;
// //       case 'rejected':
// //         statusColor = Colors.red;
// //         statusIcon = Icons.cancel;
// //         statusText = 'Rejected';
// //         break;
// //       default:
// //         statusColor = Colors.grey;
// //         statusIcon = Icons.help_outline;
// //         statusText = application.status;
// //     }

// //     return Container(
// //       margin: EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: Offset(0, 3),
// //           ),
// //         ],
// //       ),
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Status and Date Row
// //             Row(
// //               children: [
// //                 Container(
// //                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                   decoration: BoxDecoration(
// //                     color: statusColor.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(20),
// //                   ),
// //                   child: Row(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       Icon(statusIcon, size: 14, color: statusColor),
// //                       SizedBox(width: 4),
// //                       Text(
// //                         statusText,
// //                         style: TextStyle(
// //                           color: statusColor,
// //                           fontWeight: FontWeight.w500,
// //                           fontSize: 12,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Spacer(),
// //                 Text(
// //                   _formatDate(application.appliedAt),
// //                   style: TextStyle(color: Colors.grey[500], fontSize: 12),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 12),

// //             // Campaign Title
// //             Text(
// //               application.campaignTitle,
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black87,
// //               ),
// //             ),
// //             SizedBox(height: 8),

// //             // Message if exists
// //             if (application.message != null && application.message!.isNotEmpty)
// //               Container(
// //                 padding: EdgeInsets.all(12),
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[100],
// //                   borderRadius: BorderRadius.circular(8),
// //                 ),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       'Your Message:',
// //                       style: TextStyle(
// //                         fontWeight: FontWeight.w500,
// //                         fontSize: 12,
// //                         color: Colors.grey[700],
// //                       ),
// //                     ),
// //                     SizedBox(height: 4),
// //                     Text(
// //                       application.message!,
// //                       style: TextStyle(color: Colors.grey[700], fontSize: 14),
// //                     ),
// //                   ],
// //                 ),
// //               ),

// //             SizedBox(height: 12),

// //             // Application Info
// //             Row(
// //               children: [
// //                 Icon(Icons.person_outline, size: 16, color: Colors.grey),
// //                 SizedBox(width: 4),
// //                 Text(
// //                   application.influencerName,
// //                   style: TextStyle(color: Colors.grey[600]),
// //                 ),
// //                 SizedBox(width: 16),
// //                 Icon(Icons.email_outlined, size: 16, color: Colors.grey),
// //                 SizedBox(width: 4),
// //                 Expanded(
// //                   child: Text(
// //                     application.influencerEmail,
// //                     style: TextStyle(color: Colors.grey[600]),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //               ],
// //             ),

// //             // Response date if responded
// //             if (application.respondedAt != null)
// //               Padding(
// //                 padding: EdgeInsets.only(top: 8),
// //                 child: Text(
// //                   'Responded on: ${_formatDate(application.respondedAt!)}',
// //                   style: TextStyle(
// //                     color: Colors.grey[500],
// //                     fontSize: 12,
// //                     fontStyle: FontStyle.italic,
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   String _formatDate(DateTime date) {
// //     return '${date.day}/${date.month}/${date.year}';
// //   }
// // }
// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MyApplicationsScreen extends StatefulWidget {
//   @override
//   _MyApplicationsScreenState createState() => _MyApplicationsScreenState();
// }

// class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
//   List<ApplicationModel>? _applications;
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _loadApplications();
//   }

//   Future<void> _loadApplications() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final applicationProvider = Provider.of<ApplicationProvider>(
//         context,
//         listen: false,
//       );

//       final applications = await applicationProvider.fetchMyApplications();

//       setState(() {
//         _applications = applications;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text(
//           'My Applications',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black87),
//         actions: [
//           IconButton(icon: Icon(Icons.refresh), onPressed: _loadApplications),
//         ],
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(),
//             SizedBox(height: 16),
//             Text('Loading your applications...'),
//           ],
//         ),
//       );
//     }

//     if (_error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 60, color: Colors.red),
//             SizedBox(height: 16),
//             Text('Error loading applications'),
//             SizedBox(height: 8),
//             Text(
//               _error!,
//               style: TextStyle(color: Colors.grey),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _loadApplications,
//               child: Text('Retry'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     if (_applications == null || _applications!.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
//             SizedBox(height: 16),
//             Text(
//               'No Applications Yet',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[600],
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Apply to campaigns to see them here',
//               style: TextStyle(color: Colors.grey[500]),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Browse Campaigns'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return RefreshIndicator(
//       onRefresh: _loadApplications,
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: _applications!.length,
//         itemBuilder: (context, index) {
//           final application = _applications![index];
//           return _buildApplicationCard(application);
//         },
//       ),
//     );
//   }

//   Widget _buildApplicationCard(ApplicationModel application) {
//     Color statusColor;
//     IconData statusIcon;
//     String statusText;

//     switch (application.status.toLowerCase()) {
//       case 'pending':
//         statusColor = Colors.orange;
//         statusIcon = Icons.hourglass_empty;
//         statusText = 'Pending';
//         break;
//       case 'accepted':
//         statusColor = Colors.green;
//         statusIcon = Icons.check_circle;
//         statusText = 'Accepted';
//         break;
//       case 'rejected':
//         statusColor = Colors.red;
//         statusIcon = Icons.cancel;
//         statusText = 'Rejected';
//         break;
//       default:
//         statusColor = Colors.grey;
//         statusIcon = Icons.help_outline;
//         statusText = application.status;
//     }

//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
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
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Status and Date Row
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(statusIcon, size: 14, color: statusColor),
//                       SizedBox(width: 4),
//                       Text(
//                         statusText,
//                         style: TextStyle(
//                           color: statusColor,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Spacer(),
//                 Text(
//                   _formatDate(application.appliedAt),
//                   style: TextStyle(color: Colors.grey[500], fontSize: 12),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Campaign Title
//             Text(
//               application.campaignTitle,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 8),

//             // Message if exists
//             if (application.message != null && application.message!.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Your Message:',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       application.message!,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),

//             SizedBox(height: 12),

//             // Application Info
//             Row(
//               children: [
//                 Icon(Icons.person_outline, size: 16, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Text(
//                   application.influencerName,
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//                 SizedBox(width: 16),
//                 Icon(Icons.email_outlined, size: 16, color: Colors.grey),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     application.influencerEmail,
//                     style: TextStyle(color: Colors.grey[600]),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),

//             // Response date if responded
//             if (application.respondedAt != null)
//               Padding(
//                 padding: EdgeInsets.only(top: 8),
//                 child: Text(
//                   'Responded on: ${_formatDate(application.respondedAt!)}',
//                   style: TextStyle(
//                     color: Colors.grey[500],
//                     fontSize: 12,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }
import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApplicationsScreen extends StatefulWidget {
  @override
  _MyApplicationsScreenState createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen>
    with TickerProviderStateMixin {
  List<ApplicationModel>? _applications;
  bool _isLoading = true;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
      final applicationProvider = Provider.of<ApplicationProvider>(
        context,
        listen: false,
      );

      final applications = await applicationProvider.fetchMyApplications();

      setState(() {
        _applications = applications;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
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
      foregroundColor: Color(0xFF1E293B),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'My Applications',
          style: TextStyle(
            color: Color(0xFF1E293B),
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
              colors: [Colors.white, Color(0xFFF1F5F9)],
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF3B82F6).withOpacity(0.3),
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Loading your applications...',
                style: TextStyle(
                  color: Color(0xFF64748B),
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
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadApplications,
                icon: Icon(Icons.refresh_rounded),
                label: Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
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

    if (_applications == null || _applications!.isEmpty) {
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
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Color(0xFFE2E8F0), width: 2),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  size: 60,
                  color: Color(0xFF94A3B8),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'No Applications Yet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Start applying to campaigns and track your applications here',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.search_rounded),
                label: Text('Browse Campaigns'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildStatsHeader(),
          RefreshIndicator(
            onRefresh: _loadApplications,
            color: Color(0xFF3B82F6),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(20),
              itemCount: _applications!.length,
              itemBuilder: (context, index) {
                final application = _applications![index];
                return _buildApplicationCard(application, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader() {
    final totalApplications = _applications?.length ?? 0;
    final pendingCount =
        _applications
            ?.where((app) => app.status.toLowerCase() == 'pending')
            .length ??
        0;
    final acceptedCount =
        _applications
            ?.where((app) => app.status.toLowerCase() == 'accepted')
            .length ??
        0;
    final rejectedCount =
        _applications
            ?.where((app) => app.status.toLowerCase() == 'rejected')
            .length ??
        0;

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.04),
            blurRadius: 24,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                'Total',
                totalApplications.toString(),
                Color(0xFF3B82F6),
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
              color: Color(0xFF64748B),
            ),
          ),
        ],
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
                    color: Color(0xFF1E293B).withOpacity(0.04),
                    blurRadius: 24,
                    offset: Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Color(0xFFE2E8F0), width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 16, color: statusColor),
                              SizedBox(width: 6),
                              Text(
                                statusText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
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
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatDate(application.appliedAt),
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
                        color: Color(0xFF1E293B),
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Message Section
                    if (application.message != null &&
                        application.message!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.message_rounded,
                                  size: 16,
                                  color: Color(0xFF3B82F6),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Your Message',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF3B82F6),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              application.message!,
                              style: TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),

                    // Applicant Info
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF3B82F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  application.influencerName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  application.influencerEmail,
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Response Date
                    if (application.respondedAt != null)
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 16,
                                color: statusColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Responded on ${_formatDate(application.respondedAt!)}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
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
