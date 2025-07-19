// import 'package:creatorcrew/infliencers/PrifleCreation/Models/AplicatiomModel.dart';
// import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MyApplicationsScreen extends StatefulWidget {
//   @override
//   _MyApplicationsScreenState createState() => _MyApplicationsScreenState();
// }

// class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ApplicationProvider>(
//         context,
//         listen: false,
//       ).fetchMyApplications();
//     });
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
//       ),
//       body: Consumer<ApplicationProvider>(
//         builder: (context, applicationProvider, child) {
//           if (applicationProvider.isLoading) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading your applications...'),
//                 ],
//               ),
//             );
//           }

//           return FutureBuilder<List<ApplicationModel>>(
//             future: applicationProvider.fetchMyApplications(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasError) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, size: 60, color: Colors.red),
//                       SizedBox(height: 16),
//                       Text('Error loading applications'),
//                       SizedBox(height: 8),
//                       Text(
//                         snapshot.error.toString(),
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               final applications = snapshot.data ?? [];

//               if (applications.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.assignment_outlined,
//                         size: 80,
//                         color: Colors.grey[400],
//                       ),
//                       SizedBox(height: 16),
//                       Text(
//                         'No Applications Yet',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Apply to campaigns to see them here',
//                         style: TextStyle(color: Colors.grey[500]),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text('Browse Campaigns'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: EdgeInsets.all(16),
//                 itemCount: applications.length,
//                 itemBuilder: (context, index) {
//                   final application = applications[index];
//                   return _buildApplicationCard(application);
//                 },
//               );
//             },
//           );
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

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  List<ApplicationModel>? _applications;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadApplications();
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Applications',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadApplications),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your applications...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red),
            SizedBox(height: 16),
            Text('Error loading applications'),
            SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadApplications,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_applications == null || _applications!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No Applications Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Apply to campaigns to see them here',
              style: TextStyle(color: Colors.grey[500]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Browse Campaigns'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadApplications,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _applications!.length,
        itemBuilder: (context, index) {
          final application = _applications![index];
          return _buildApplicationCard(application);
        },
      ),
    );
  }

  Widget _buildApplicationCard(ApplicationModel application) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (application.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = 'Pending';
        break;
      case 'accepted':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Accepted';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Rejected';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
        statusText = application.status;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date Row
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Text(
                  _formatDate(application.appliedAt),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Campaign Title
            Text(
              application.campaignTitle,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),

            // Message if exists
            if (application.message != null && application.message!.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Message:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      application.message!,
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 12),

            // Application Info
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  application.influencerName,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(width: 16),
                Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    application.influencerEmail,
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Response date if responded
            if (application.respondedAt != null)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Responded on: ${_formatDate(application.respondedAt!)}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
