import 'package:creatorcrew/Brand/Authentication/Screens/LandingPaage.dart';
import 'package:creatorcrew/Brand/Authentication/providers/Login-Provider.dart';
import 'package:creatorcrew/Brand/Dashboard/Screens/InfluencerGlassmorphicAppbar.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/AplicationScreen.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Chat/InfluencerChatScreen.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/HOmeScreenInfluencers.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Infleuncercampaion.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/IprofileScreen.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Meetings/InflluencersMeetingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../PrifleCreation/providers/InfluencerOnboardingProvider.dart';

class InfluencerDashboard extends StatefulWidget {
  @override
  _InfluencerDashboardState createState() => _InfluencerDashboardState();
}

class _InfluencerDashboardState extends State<InfluencerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // Center(
    //   child: Text(
    //     'Home Page',
    //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //   ),
    // ),
    InfluencerHomeScreen(),
    // Center(
    //   child: Text(
    //     'Campaigns Page',
    //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //   ),
    // ),
    InfluencerCampaignsScreen(),
    // Center(
    //   child: Text(
    //     'Meetings Page',
    //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //   ),
    // ),
    InfluencerMeetingsScreen(),
    // Center(
    //   child: Text(
    //     'Profile Page',
    //     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //   ),
    // ),
    InfluencerProfileScreen(),

    // InfluencerHome(),
    // InfluencerCampaigns(),
    // InfluencerMeetings(),
    // InfluencerProfile(),
  ];

  final List<String> _pageTitles = [
    'Home',
    'My Campaigns',
    'Meetings',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    // Load influencer profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<InfluencerOnboardingProvider>(
        context,
        listen: false,
      ).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: InfluencerGlassmorphicAppBar(
        currentPageTitle: _pageTitles[_currentIndex],
        onbookmarkTap: () {
          // Navigate to applications screen instead of bookmarks
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyApplicationsScreen()),
          );
        },

        onNotificationTap: () {
          // Handle notification tap
          print('Notifications tapped');
        },
        onChatTap: () {
          // Handle chat tap
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InfluencerChatScreen()),
          );
        },
        onProfileMenuSelect: (String value) {
          switch (value) {
            case 'profile':
              setState(() {
                _currentIndex = 3; // Navigate to Profile tab
              });
              break;
            case 'settings':
              // Navigate to settings
              break;
            case 'logout':
              _handleLogout();
              break;
          }
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white, Colors.purple.shade50],
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_outlined, Icons.home, 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.campaign_outlined, Icons.campaign, 1),
                label: 'Campaigns',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  Icons.calendar_today_outlined,
                  Icons.calendar_today,
                  2,
                ),
                label: 'Meetings',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.person_outline, Icons.person, 3),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData outlined, IconData filled, int index) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.blue.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_currentIndex == index ? filled : outlined, size: 24),
    );
  }

  void _handleLogout() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();

      // Navigate to landing page and clear all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
