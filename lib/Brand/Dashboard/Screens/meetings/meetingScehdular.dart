import 'package:creatorcrew/Brand/Dashboard/models/meetingModel.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/meetingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MeetingSchedulerScreen extends StatefulWidget {
  final String chatRoomId;
  final String brandId;
  final String influencerId;
  final String brandName;
  final String influencerName;
  final String campaignTitle;

  const MeetingSchedulerScreen({
    Key? key,
    required this.chatRoomId,
    required this.brandId,
    required this.influencerId,
    required this.brandName,
    required this.influencerName,
    required this.campaignTitle,
  }) : super(key: key);

  @override
  _MeetingSchedulerScreenState createState() => _MeetingSchedulerScreenState();
}

class _MeetingSchedulerScreenState extends State<MeetingSchedulerScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedTimeSlot;
  MeetingType _selectedType = MeetingType.video;
  int _selectedDuration = 30;
  final TextEditingController _agendaController = TextEditingController();

  @override
  void dispose() {
    _agendaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0FDF4),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildSchedulerContent()),
          _buildScheduleButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: Text(
        'Schedule Meeting',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildSchedulerContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeetingInfo(),
          SizedBox(height: 24),
          _buildCalendar(),
          SizedBox(height: 24),
          _buildTimeSlots(),
          SizedBox(height: 24),
          _buildMeetingOptions(),
        ],
      ),
    );
  }

  Widget _buildMeetingInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.campaign, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Meeting Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInfoRow('Campaign', widget.campaignTitle),
          _buildInfoRow('With', widget.influencerName),
          SizedBox(height: 16),
          TextField(
            controller: _agendaController,
            decoration: InputDecoration(
              labelText: 'Meeting Agenda (Optional)',
              hintText: 'What would you like to discuss?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFDCFCE7)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF22C55E)),
              ),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TableCalendar<Event>(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(Duration(days: 90)),
            focusedDay: _selectedDate,
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) => [],
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Color(0xFF22C55E).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF166534),
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _selectedTimeSlot = null; // Reset time slot selection
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    final slots = context.read<MeetingProvider>().generateTimeSlots(
      _selectedDate,
    );

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Select Time',
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
            height: 200,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isSelected = _selectedTimeSlot == slot;
                final isPast = slot.startTime.isBefore(DateTime.now());

                return InkWell(
                  onTap:
                      isPast
                          ? null
                          : () {
                            setState(() {
                              _selectedTimeSlot = slot;
                            });
                          },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isPast
                              ? Colors.grey[100]
                              : isSelected
                              ? Color(0xFF22C55E)
                              : Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            isPast
                                ? Colors.grey[300]!
                                : isSelected
                                ? Color(0xFF22C55E)
                                : Color(0xFFDCFCE7),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${slot.startTime.hour.toString().padLeft(2, '0')}:${slot.startTime.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color:
                              isPast
                                  ? Colors.grey[400]
                                  : isSelected
                                  ? Colors.white
                                  : Color(0xFF166534),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingOptions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFDCFCE7)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF22C55E).withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF22C55E), size: 20),
              SizedBox(width: 8),
              Text(
                'Meeting Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF166534),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Meeting Type',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                MeetingType.values.map((type) {
                  final isSelected = _selectedType == type;
                  return ChoiceChip(
                    label: Text(_getMeetingTypeText(type)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedType = type;
                        });
                      }
                    },
                    selectedColor: Color(0xFF22C55E),
                    backgroundColor: Color(0xFFF0FDF4),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF166534),
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
          ),
          SizedBox(height: 16),
          Text(
            'Duration',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children:
                [15, 30, 45, 60].map((duration) {
                  final isSelected = _selectedDuration == duration;
                  return ChoiceChip(
                    label: Text('${duration}min'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDuration = duration;
                        });
                      }
                    },
                    selectedColor: Color(0xFF22C55E),
                    backgroundColor: Color(0xFFF0FDF4),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF166534),
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SafeArea(
        child: Consumer<MeetingProvider>(
          builder: (context, meetingProvider, child) {
            final canSchedule = _selectedTimeSlot != null;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    canSchedule && !meetingProvider.isScheduling
                        ? _scheduleMeeting
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child:
                    meetingProvider.isScheduling
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Scheduling Meeting...'),
                          ],
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Schedule Meeting',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _scheduleMeeting() async {
    if (_selectedTimeSlot == null) return;

    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTimeSlot!.startTime.hour,
      _selectedTimeSlot!.startTime.minute,
    );

    final success = await context.read<MeetingProvider>().scheduleMeeting(
      chatRoomId: widget.chatRoomId,
      brandId: widget.brandId,
      influencerId: widget.influencerId,
      brandName: widget.brandName,
      influencerName: widget.influencerName,
      campaignTitle: widget.campaignTitle,
      scheduledDateTime: scheduledDateTime,
      durationMinutes: _selectedDuration,
      type: _selectedType,
      agenda:
          _agendaController.text.trim().isNotEmpty
              ? _agendaController.text.trim()
              : null,
    );

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Meeting scheduled successfully!'),
            ],
          ),
          backgroundColor: Color(0xFF22C55E),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to schedule meeting. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getMeetingTypeText(MeetingType type) {
    switch (type) {
      case MeetingType.video:
        return 'Video Call';
      case MeetingType.audio:
        return 'Audio Call';
      case MeetingType.phone:
        return 'Phone Call';
      case MeetingType.inPerson:
        return 'In-Person';
    }
  }
}

class Event {}
