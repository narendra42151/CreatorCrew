import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/meetingProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InfluencerMeetingsScreen extends StatefulWidget {
  @override
  _InfluencerMeetingsScreenState createState() =>
      _InfluencerMeetingsScreenState();
}

class _InfluencerMeetingsScreenState extends State<InfluencerMeetingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MeetingProvider>().fetchInfluencerMeetings();
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
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Colors.white, Color(0xFFF1F3F4)],
          ),
        ),
        child: Column(
          children: [
            // Professional spacing for glassmorphic app bar
            SizedBox(height: 120),

            // Professional tab bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 16,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Color(0xFFE5E7EB), width: 1),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFF2563EB),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Color(0xFF2563EB),
                unselectedLabelColor: Color(0xFF6B7280),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.25,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.25,
                ),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(height: 48, text: 'All'),
                  Tab(height: 48, text: 'Upcoming'),
                  Tab(height: 48, text: 'Today'),
                  Tab(height: 48, text: 'Completed'),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Content area
            Expanded(
              child: Consumer<MeetingProvider>(
                builder: (context, meetingProvider, child) {
                  if (meetingProvider.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2563EB),
                              ),
                              strokeWidth: 2.5,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Loading meetings...',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
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
                        meetingProvider.getMeetingsByStatus(
                          MeetingStatus.completed,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingsList(List<Meeting> meetings) {
    if (meetings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 32,
                color: Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'No meetings scheduled',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your upcoming meetings will appear here',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MeetingProvider>().fetchInfluencerMeetings();
      },
      color: Color(0xFF2563EB),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          return InfluencerMeetingCard(meeting: meeting);
        },
      ),
    );
  }
}

class InfluencerMeetingCard extends StatelessWidget {
  final Meeting meeting;

  const InfluencerMeetingCard({Key? key, required this.meeting})
    : super(key: key);

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
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFFE5E7EB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Professional header
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
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
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    letterSpacing: -0.025,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.business,
                        size: 16,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      meeting.brandName,
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content section
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time section
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.schedule,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 16),
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
                              fontSize: 16,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${DateFormat('h:mm a').format(meeting.scheduledDateTime)} • ${meeting.durationMinutes} minutes',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Agenda section
                if (meeting.agenda != null && meeting.agenda!.isNotEmpty) ...[
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notes_outlined,
                              color: Color(0xFF6B7280),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Meeting Agenda',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF374151),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          meeting.agenda!,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Meeting starting soon notification
                if (meetingProvider.isMeetingStartingSoon(meeting)) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Meeting starts soon',
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
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
                                  ? () => _handleJoinMeeting(
                                    context,
                                    meeting,
                                    meetingProvider,
                                  )
                                  : null,
                          icon: Icon(Icons.videocam, size: 18),
                          label: Text(
                            meetingProvider.canJoinMeeting(meeting)
                                ? 'Join Meeting'
                                : 'Not Available',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                meetingProvider.canJoinMeeting(meeting)
                                    ? Color(0xFF2563EB)
                                    : Color(0xFF9CA3AF),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
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

                    // Contact brand button
                    if (meeting.status == MeetingStatus.scheduled)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              () => _showContactBrandDialog(context, meeting),
                          icon: Icon(Icons.message_outlined, size: 18),
                          label: Text(
                            'Contact Brand',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF374151),
                            side: BorderSide(
                              color: Color(0xFFD1D5DB),
                              width: 1.5,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
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
        backgroundColor = Color(0xFFEBF8FF);
        textColor = Color(0xFF0369A1);
        text = 'Scheduled';
        break;
      case MeetingStatus.ongoing:
        backgroundColor = Color(0xFFECFDF5);
        textColor = Color(0xFF059669);
        text = 'In Progress';
        break;
      case MeetingStatus.completed:
        backgroundColor = Color(0xFFF3F4F6);
        textColor = Color(0xFF374151);
        text = 'Completed';
        break;
      case MeetingStatus.cancelled:
        backgroundColor = Color(0xFFFEF2F2);
        textColor = Color(0xFFDC2626);
        text = 'Cancelled';
        break;
      case MeetingStatus.rescheduled:
        backgroundColor = Color(0xFFFEF3C7);
        textColor = Color(0xFFD97706);
        text = 'Rescheduled';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.025,
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
        text = 'In Person';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Color(0xFF6B7280)),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _handleJoinMeeting(
    BuildContext context,
    Meeting meeting,
    MeetingProvider meetingProvider,
  ) async {
    // Professional loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2563EB),
                      ),
                      strokeWidth: 2.5,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Joining meeting...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    bool success = await meetingProvider.joinMeeting(meeting.meetingLink!);

    if (!success) {
      success = await meetingProvider.openUrlAlternative(meeting.meetingLink!);
    }

    Navigator.of(context).pop();

    if (!success) {
      _showMeetingLinkError(context, meeting);
    }
  }

  void _showMeetingLinkError(BuildContext context, Meeting meeting) {
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.warning_amber,
                    color: Color(0xFFDC2626),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Unable to Join Meeting',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We couldn\'t open the meeting link automatically. You can copy the link below and open it manually.',
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
                ),
                SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: meeting.meetingLink!),
                      );
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Meeting link copied to clipboard'),
                          backgroundColor: Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.copy, size: 18),
                    label: Text(
                      'Copy Meeting Link',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Meeting Link:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 4),
                      SelectableText(
                        meeting.meetingLink!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showContactBrandDialog(BuildContext context, Meeting meeting) {
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFEBF8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.message_outlined,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Contact Brand',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need to discuss this meeting with ${meeting.brandName}?',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 15),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Options:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Send a message in your chat\n'
                        '• Ask questions about meeting details\n'
                        '• Request rescheduling if needed\n'
                        '• Discuss agenda modifications',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening chat with ${meeting.brandName}...',
                      ),
                      backgroundColor: Color(0xFF2563EB),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.chat_outlined, size: 16),
                label: Text(
                  'Open Chat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: 0,
                ),
              ),
            ],
          ),
    );
  }
}
