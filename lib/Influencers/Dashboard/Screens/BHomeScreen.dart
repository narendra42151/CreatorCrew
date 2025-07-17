import 'package:flutter/material.dart';

class BHOmeScreen extends StatefulWidget {
  const BHOmeScreen({super.key});

  @override
  State<BHOmeScreen> createState() => _BHOmeScreenState();
}

class _BHOmeScreenState extends State<BHOmeScreen> {
  int _currentIndex = 0;

  // List of screen widgets to display based on selected tab
  final List<Widget> _screens = [
    // Home Screen
    Center(child: Text('Home Screen', style: TextStyle(fontSize: 24))),

    // Chat Screen
    Center(child: Text('Chat Screen', style: TextStyle(fontSize: 24))),

    // Meetings Screen
    Center(child: Text('Meetings Screen', style: TextStyle(fontSize: 24))),

    // Explore Influencers Screen
    Center(child: Text('Explore Influencers', style: TextStyle(fontSize: 24))),

    // Profile Screen
    Center(child: Text('Profile Screen', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
          type: BottomNavigationBarType.fixed, // Required for more than 3 items
          selectedItemColor: Color(0xFF4CAF50), // Green color
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
