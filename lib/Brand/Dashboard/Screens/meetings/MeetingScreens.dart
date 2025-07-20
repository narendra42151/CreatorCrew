// import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
// import 'package:creatorcrew/Brand/Dashboard/provider/meetingProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class MeetingsScreen extends StatefulWidget {
//   @override
//   _MeetingsScreenState createState() => _MeetingsScreenState();
// }

// class _MeetingsScreenState extends State<MeetingsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MeetingProvider>().fetchBrandMeetings();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Meetings'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               context.read<MeetingProvider>().fetchBrandMeetings();
//             },
//           ),
//         ],
//       ),
//       body: Consumer<MeetingProvider>(
//         builder: (context, meetingProvider, child) {
//           if (meetingProvider.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (meetingProvider.meetings.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.calendar_today, size: 80, color: Colors.grey),
//                   SizedBox(height: 16),
//                   Text(
//                     'No meetings scheduled',
//                     style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: () async {
//               await context.read<MeetingProvider>().fetchBrandMeetings();
//             },
//             child: ListView.builder(
//               padding: EdgeInsets.all(16),
//               itemCount: meetingProvider.meetings.length,
//               itemBuilder: (context, index) {
//                 final meeting = meetingProvider.meetings[index];
//                 return MeetingCard(meeting: meeting);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class MeetingCard extends StatelessWidget {
//   final Meeting meeting;

//   const MeetingCard({Key? key, required this.meeting}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final meetingProvider = context.read<MeetingProvider>();

//     return Card(
//       margin: EdgeInsets.only(bottom: 16),
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with status and type
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildStatusChip(meeting.status),
//                 _buildTypeChip(meeting.type),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Meeting title and campaign
//             Text(
//               meeting.campaignTitle,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 8),

//             // Participants
//             Row(
//               children: [
//                 Icon(Icons.people, size: 16, color: Colors.grey[600]),
//                 SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     'With ${meeting.influencerName}',
//                     style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),

//             // Date and time
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.grey[50],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.schedule, color: Colors.blue, size: 20),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           DateFormat(
//                             'EEEE, MMM d, yyyy',
//                           ).format(meeting.scheduledDateTime),
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           '${DateFormat('h:mm a').format(meeting.scheduledDateTime)} (${meeting.durationMinutes} min)',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Agenda if available
//             if (meeting.agenda != null && meeting.agenda!.isNotEmpty) ...[
//               SizedBox(height: 12),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.description, size: 16, color: Colors.grey[600]),
//                   SizedBox(width: 4),
//                   Expanded(
//                     child: Text(
//                       meeting.agenda!,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 13),
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             // Action buttons
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 // Join meeting button (only for video meetings with links)
//                 if (meeting.meetingLink != null &&
//                     meeting.type == MeetingType.video)
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       onPressed:
//                           meetingProvider.canJoinMeeting(meeting)
//                               ? () async {
//                                 final success = await meetingProvider
//                                     .joinMeeting(meeting.meetingLink!);
//                                 if (!success) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                         'Could not open meeting link',
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               }
//                               : null,
//                       icon: Icon(Icons.video_call, size: 18),
//                       label: Text(
//                         meetingProvider.canJoinMeeting(meeting)
//                             ? 'Join Meeting'
//                             : 'Not Ready',
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             meetingProvider.canJoinMeeting(meeting)
//                                 ? Colors.green
//                                 : Colors.grey,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),

//                 if (meeting.meetingLink != null &&
//                     meeting.type == MeetingType.video)
//                   SizedBox(width: 8),

//                 // Cancel meeting button (only for scheduled meetings)
//                 if (meeting.status == MeetingStatus.scheduled)
//                   Expanded(
//                     child: OutlinedButton.icon(
//                       onPressed: () => _showCancelDialog(context, meeting),
//                       icon: Icon(Icons.cancel, size: 18),
//                       label: Text('Cancel', style: TextStyle(fontSize: 12)),
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.red,
//                         side: BorderSide(color: Colors.red),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),

//             // Meeting starting soon notification
//             if (meetingProvider.isMeetingStartingSoon(meeting))
//               Container(
//                 margin: EdgeInsets.only(top: 12),
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.orange[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.orange[200]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.notification_important,
//                       color: Colors.orange,
//                       size: 16,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       'Meeting starts soon!',
//                       style: TextStyle(
//                         color: Colors.orange[800],
//                         fontWeight: FontWeight.w500,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusChip(MeetingStatus status) {
//     Color color;
//     String text;

//     switch (status) {
//       case MeetingStatus.scheduled:
//         color = Colors.blue;
//         text = 'Scheduled';
//         break;
//       case MeetingStatus.ongoing:
//         color = Colors.green;
//         text = 'Ongoing';
//         break;
//       case MeetingStatus.completed:
//         color = Colors.grey;
//         text = 'Completed';
//         break;
//       case MeetingStatus.cancelled:
//         color = Colors.red;
//         text = 'Cancelled';
//         break;
//       case MeetingStatus.rescheduled:
//         color = Colors.orange;
//         text = 'Rescheduled';
//         break;
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           color: color,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   Widget _buildTypeChip(MeetingType type) {
//     IconData icon;
//     String text;

//     switch (type) {
//       case MeetingType.video:
//         icon = Icons.video_call;
//         text = 'Video';
//         break;
//       case MeetingType.audio:
//         icon = Icons.call;
//         text = 'Audio';
//         break;
//       case MeetingType.phone:
//         icon = Icons.phone;
//         text = 'Phone';
//         break;
//       case MeetingType.inPerson:
//         icon = Icons.person;
//         text = 'In-Person';
//         break;
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 12, color: Colors.grey[600]),
//           SizedBox(width: 4),
//           Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   void _showCancelDialog(BuildContext context, Meeting meeting) {
//     final reasonController = TextEditingController();

//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text('Cancel Meeting'),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Are you sure you want to cancel this meeting?'),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: reasonController,
//                   decoration: InputDecoration(
//                     labelText: 'Cancellation reason',
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter reason for cancellation',
//                   ),
//                   maxLines: 3,
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Keep Meeting'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (reasonController.text.trim().isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Please provide a cancellation reason'),
//                       ),
//                     );
//                     return;
//                   }

//                   Navigator.pop(context);

//                   final success = await context
//                       .read<MeetingProvider>()
//                       .cancelMeeting(meeting.id, reasonController.text.trim());

//                   if (success) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Meeting cancelled successfully')),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to cancel meeting')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                 child: Text(
//                   'Cancel Meeting',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//     );
//   }
// }
import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/meetingProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MeetingsScreen extends StatefulWidget {
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeetingProvider>().fetchBrandMeetings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text(
          'Meetings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF66BB6A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              context.read<MeetingProvider>().fetchBrandMeetings();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 2,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: 'ALL'),
            Tab(text: 'UPCOMING'),
            Tab(text: 'TODAY'),
            Tab(text: 'COMPLETED'),
          ],
        ),
      ),
      body: Consumer<MeetingProvider>(
        builder: (context, meetingProvider, child) {
          if (meetingProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF66BB6A),
                    ),
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading meetings...',
                    style: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildMeetingsList(meetingProvider.meetings),
              _buildMeetingsList(meetingProvider.getUpcomingMeetings()),
              _buildMeetingsList(meetingProvider.getTodaysMeetings()),
              _buildMeetingsList(
                meetingProvider.getMeetingsByStatus(MeetingStatus.completed),
              ),
            ],
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Navigate to schedule meeting screen
      //   },
      //   backgroundColor: Color(0xFF66BB6A),
      //   foregroundColor: Colors.white,
      //   elevation: 2,
      //   icon: Icon(Icons.add, size: 20),
      //   label: Text(
      //     'Schedule Meeting',
      //     style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      //   ),
      // ),
    );
  }

  Widget _buildMeetingsList(List<Meeting> meetings) {
    if (meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_note, size: 40, color: Color(0xFFBDBDBD)),
            ),
            SizedBox(height: 24),
            Text(
              'No meetings found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your scheduled meetings will appear here',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MeetingProvider>().fetchBrandMeetings();
      },
      color: Color(0xFF66BB6A),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return MeetingCard(meeting: meeting);
        },
      ),
    );
  }
}

class MeetingCard extends StatelessWidget {
  final Meeting meeting;

  const MeetingCard({Key? key, required this.meeting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final meetingProvider = context.read<MeetingProvider>();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: Color(0xFFF0F0F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF66BB6A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusChip(meeting.status),
                    _buildTypeChip(meeting.type),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  meeting.campaignTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.white70),
                    SizedBox(width: 6),
                    Text(
                      'Meeting with ${meeting.influencerName}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: Color(0xFF66BB6A),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat(
                              'EEEE, MMMM d, yyyy',
                            ).format(meeting.scheduledDateTime),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF424242),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '${DateFormat('h:mm a').format(meeting.scheduledDateTime)} • ${meeting.durationMinutes} minutes',
                            style: TextStyle(
                              color: Color(0xFF9E9E9E),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Agenda if available
                if (meeting.agenda != null && meeting.agenda!.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF1F8E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.notes,
                          color: Color(0xFF66BB6A),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Agenda',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF424242),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              meeting.agenda!,
                              style: TextStyle(
                                color: Color(0xFF9E9E9E),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                // Meeting starting soon notification
                if (meetingProvider.isMeetingStartingSoon(meeting)) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFFFE082)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Color(0xFFFF8F00),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Meeting starts soon!',
                          style: TextStyle(
                            color: Color(0xFFFF8F00),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Action buttons
                SizedBox(height: 24),
                Row(
                  children: [
                    // Join meeting button
                    if (meeting.meetingLink != null &&
                        meeting.type == MeetingType.video)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              meetingProvider.canJoinMeeting(meeting)
                                  ? () async {
                                    final success = await meetingProvider
                                        .joinMeeting(meeting.meetingLink!);
                                    if (!success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Could not open meeting link',
                                          ),
                                          backgroundColor: Color(0xFFEF5350),
                                        ),
                                      );
                                    }
                                  }
                                  : null,
                          icon: Icon(Icons.videocam, size: 18),
                          label: Text(
                            meetingProvider.canJoinMeeting(meeting)
                                ? 'Join Meeting'
                                : 'Not Ready',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                meetingProvider.canJoinMeeting(meeting)
                                    ? Color(0xFF66BB6A)
                                    : Color(0xFFBDBDBD),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),

                    if (meeting.meetingLink != null &&
                        meeting.type == MeetingType.video)
                      SizedBox(width: 12),

                    // Cancel meeting button
                    if (meeting.status == MeetingStatus.scheduled)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCancelDialog(context, meeting),
                          icon: Icon(Icons.close, size: 18),
                          label: Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFEF5350),
                            side: BorderSide(
                              color: Color(0xFFEF5350),
                              width: 1,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(MeetingStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case MeetingStatus.scheduled:
        backgroundColor = Color(0xFFE3F2FD);
        textColor = Color(0xFF1976D2);
        text = 'Scheduled';
        break;
      case MeetingStatus.ongoing:
        backgroundColor = Color(0xFFE8F5E8);
        textColor = Color(0xFF388E3C);
        text = 'Ongoing';
        break;
      case MeetingStatus.completed:
        backgroundColor = Color(0xFFF5F5F5);
        textColor = Color(0xFF757575);
        text = 'Completed';
        break;
      case MeetingStatus.cancelled:
        backgroundColor = Color(0xFFFFEBEE);
        textColor = Color(0xFFD32F2F);
        text = 'Cancelled';
        break;
      case MeetingStatus.rescheduled:
        backgroundColor = Color(0xFFFFF8E1);
        textColor = Color(0xFFFF8F00);
        text = 'Rescheduled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTypeChip(MeetingType type) {
    IconData icon;
    String text;

    switch (type) {
      case MeetingType.video:
        icon = Icons.videocam;
        text = 'Video Call';
        break;
      case MeetingType.audio:
        icon = Icons.call;
        text = 'Audio Call';
        break;
      case MeetingType.phone:
        icon = Icons.phone;
        text = 'Phone Call';
        break;
      case MeetingType.inPerson:
        icon = Icons.person;
        text = 'In-Person';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Meeting meeting) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.warning_amber,
                    color: Color(0xFFEF5350),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Cancel Meeting',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF424242),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to cancel this meeting with ${meeting.influencerName}?',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    labelText: 'Cancellation reason',
                    hintText: 'Please provide a reason for cancellation',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Color(0xFF66BB6A)),
                    ),
                    labelStyle: TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 14,
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Keep Meeting',
                  style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (reasonController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please provide a cancellation reason'),
                        backgroundColor: Color(0xFFEF5350),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  final success = await context
                      .read<MeetingProvider>()
                      .cancelMeeting(meeting.id, reasonController.text.trim());

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Meeting cancelled successfully'
                            : 'Failed to cancel meeting',
                      ),
                      backgroundColor:
                          success ? Color(0xFF66BB6A) : Color(0xFFEF5350),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFEF5350),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'Cancel Meeting',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ],
          ),
    );
  }
}
