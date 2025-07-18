import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/BrandProfileScreen.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/GlassMorphicAppbar.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/homeScreenContent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandHomeNav extends StatefulWidget {
  const BrandHomeNav({Key? key}) : super(key: key);

  @override
  _BrandHomeNavState createState() => _BrandHomeNavState();
}

class _BrandHomeNavState extends State<BrandHomeNav> {
  int _currentIndex = 0;
  bool _hasUnreadNotifications = true;

  // List of screens for the bottom navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens
    _screens = [
      // Home Screen - now using BrandHomeContent
      BrandHomeContent(),

      // Chat Screen
      Center(child: Text('Chat Screen', style: TextStyle(fontSize: 24))),

      // Meetings Screen
      Center(child: Text('Meetings Screen', style: TextStyle(fontSize: 24))),

      // Explore Influencers Screen
      Center(
        child: Text('Explore Influencers', style: TextStyle(fontSize: 24)),
      ),

      // Profile Screen
      BrandProfileScreen(),
    ];

    // Load brand info when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandInfoProvider>(context, listen: false).fetchBrandInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: GlassmorphicAppBar(
        hasUnreadNotifications: _hasUnreadNotifications,
        onNotificationTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Notifications')));
        },
        onChatTap: () {
          setState(() {
            _currentIndex = 1; // Switch to chat tab
          });
        },
        onProfileMenuSelect: (value) {
          if (value == 'logout') {
            // Logout action
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Logging out...')));
          } else if (value == 'profile') {
            // Navigate to profile
            setState(() {
              _currentIndex = 4; // Switch to profile tab
            });
          } else if (value == 'settings') {
            // Navigate to settings
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Settings')));
          }
        },
      ),
      body: SafeArea(
        top: false, // Content can go behind app bar
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF4CAF50),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Meetings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
