import 'package:creatorcrew/Influencers/Authentication/Screens/LandingPaage.dart';
import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Influencers/Authentication/providers/Login-Provider.dart'
    as login;
import 'package:creatorcrew/Influencers/Dashboard/Screens/BDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authProvider = Provider.of<login.AuthProvider>(
      context,
      listen: false,
    );
    final brandInfoProvider = Provider.of<BrandInfoProvider>(
      context,
      listen: false,
    );

    // Check if Firebase has a current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Also check shared preferences (as a backup)
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole');

    // Short delay for smoother UX
    await Future.delayed(Duration(milliseconds: 1500));

    if (currentUser != null && isLoggedIn && userRole == 'brand') {
      // Fetch brand info before navigating
      await brandInfoProvider.fetchBrandInfo();

      // Navigate to brand dashboard
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => BrandHomeNav()));
    } else {
      // Navigate to landing page
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));

      // Clear any stale session data if there's a mismatch
      if (isLoggedIn && currentUser == null) {
        await prefs.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/l.jpg',
              width: 150,
              // If you don't have this asset, replace with:
              // Icon(Icons.group, size: 80, color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Creator Crew',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
