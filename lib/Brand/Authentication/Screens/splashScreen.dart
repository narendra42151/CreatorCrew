// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:creatorcrew/Influencers/Authentication/Screens/LandingPaage.dart';
// // import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
// // import 'package:creatorcrew/Influencers/Authentication/providers/Login-Provider.dart'
// //     as login;
// // import 'package:creatorcrew/Influencers/Dashboard/Screens/BDashboard.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({Key? key}) : super(key: key);

// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkAuth();
// //   }

// //   Future<void> _checkAuth() async {
// //     final authProvider = Provider.of<login.AuthProvider>(
// //       context,
// //       listen: false,
// //     );
// //     final brandInfoProvider = Provider.of<BrandInfoProvider>(
// //       context,
// //       listen: false,
// //     );

// //     // Check if Firebase has a current user
// //     User? currentUser = FirebaseAuth.instance.currentUser;

// //     // Short delay for smoother UX
// //     await Future.delayed(Duration(milliseconds: 1500));

// //     if (currentUser != null) {
// //       // User is logged in with Firebase - get their role from Firestore
// //       final userDoc =
// //           await FirebaseFirestore.instance
// //               .collection('users')
// //               .doc(currentUser.email)
// //               .get();

// //       if (userDoc.exists) {
// //         final userRole = userDoc['role'];

// //         // Save to SharedPreferences for backup
// //         final prefs = await SharedPreferences.getInstance();
// //         await prefs.setBool('isLoggedIn', true);
// //         await prefs.setString('userRole', userRole);

// //         if (userRole == 'brand') {
// //           // Fetch brand info before navigating
// //           await brandInfoProvider.fetchBrandInfo();
// //           Navigator.of(
// //             context,
// //           ).pushReplacement(MaterialPageRoute(builder: (_) => BrandHomeNav()));
// //           return;
// //         } else if (userRole == 'influencer') {
// //           // Navigate to influencer dashboard
// //           // Navigator.of(context).pushReplacement(
// //           //   MaterialPageRoute(builder: (_) => page()),
// //           // );
// //           // return;
// //         }
// //       }
// //     }

// //     // If we get here, user is not properly authenticated
// //     Navigator.of(
// //       context,
// //     ).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Image.asset(
// //               'assets/l.jpg',
// //               width: 150,
// //               // If you don't have this asset, replace with:
// //               // Icon(Icons.group, size: 80, color: Theme.of(context).primaryColor),
// //             ),
// //             SizedBox(height: 30),
// //             CircularProgressIndicator(),
// //             SizedBox(height: 20),
// //             Text(
// //               'Creator Crew',
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:creatorcrew/Brand/Authentication/Screens/LandingPaage.dart';
// import 'package:creatorcrew/Brand/Authentication/providers/BrandInfoProvider.dart';
// import 'package:creatorcrew/Brand/Authentication/providers/Login-Provider.dart'
//     as login;
// import 'package:creatorcrew/Brand/Dashboard/Screens/BDashboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkAuth();
//   }

//   Future<void> _checkAuth() async {
//     final authProvider = Provider.of<login.AuthProvider>(
//       context,
//       listen: false,
//     );
//     final brandInfoProvider = Provider.of<BrandInfoProvider>(
//       context,
//       listen: false,
//     );

//     // Check if Firebase has a current user
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     // Short delay for smoother UX
//     await Future.delayed(Duration(milliseconds: 1500));

//     if (currentUser != null) {
//       // User is logged in with Firebase - get their role from Firestore
//       final userDoc =
//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(currentUser.email)
//               .get();

//       if (userDoc.exists) {
//         final userRole = userDoc['role'];

//         // Save to SharedPreferences for backup
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('isLoggedIn', true);
//         await prefs.setString('userRole', userRole);

//         if (userRole == 'brand') {
//           // Fetch brand info before navigating - this will automatically save to SharedPreferences
//           final brandInfo = await brandInfoProvider.fetchBrandInfo();

//           // Additional check to ensure data is in SharedPreferences
//           if (brandInfo != null) {
//             await prefs.setString('brand_name', brandInfo.brandName);
//             if (brandInfo.logoUrl != null) {
//               await prefs.setString('brand_logo_url', brandInfo.logoUrl!);
//             }
//           }

//           Navigator.of(
//             context,
//           ).pushReplacement(MaterialPageRoute(builder: (_) => BrandHomeNav()));
//           return;
//         } else if (userRole == 'influencer') {
//           // Navigate to influencer dashboard
//           // Navigator.of(context).pushReplacement(
//           //   MaterialPageRoute(builder: (_) => page()),
//           // );
//           // return;
//         }
//       }
//     }

//     // If we get here, user is not properly authenticated
//     Navigator.of(
//       context,
//     ).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/l.jpg',
//               width: 150,
//               // If you don't have this asset, replace with:
//               // Icon(Icons.group, size: 80, color: Theme.of(context).primaryColor),
//             ),
//             SizedBox(height: 30),
//             CircularProgressIndicator(),
//             SizedBox(height: 20),
//             Text(
//               'Creator Crew',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creatorcrew/Brand/Authentication/Screens/LandingPaage.dart';
import 'package:creatorcrew/Brand/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Brand/Authentication/providers/Login-Provider.dart'
    as login;
import 'package:creatorcrew/Brand/Dashboard/Screens/BDashboard.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Influencersdashboar.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
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
    final influencerProvider = Provider.of<InfluencerOnboardingProvider>(
      context,
      listen: false,
    );

    // Check if Firebase has a current user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Short delay for smoother UX
    await Future.delayed(Duration(milliseconds: 1500));

    if (currentUser != null) {
      // User is logged in with Firebase - get their role from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .get();

      if (userDoc.exists) {
        final userRole = userDoc['role'];

        // Save to SharedPreferences for backup
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userRole', userRole);

        if (userRole == 'brand') {
          // Fetch brand info before navigating
          final brandInfo = await brandInfoProvider.fetchBrandInfo();

          // Additional check to ensure data is in SharedPreferences
          if (brandInfo != null) {
            await prefs.setString('brand_name', brandInfo.brandName);
            if (brandInfo.logoUrl != null) {
              await prefs.setString('brand_logo_url', brandInfo.logoUrl!);
            }
          }

          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => BrandHomeNav()));
          return;
        } else if (userRole == 'influencer') {
          // Fetch influencer profile before navigating
          final influencerProfile = await influencerProvider.fetchProfile();

          // Additional check to ensure data is in SharedPreferences
          if (influencerProfile != null) {
            await prefs.setString(
              'influencer_name',
              influencerProfile.fullName,
            );
            if (influencerProfile.profilePictureUrl != null) {
              await prefs.setString(
                'influencer_profile_url',
                influencerProfile.profilePictureUrl!,
              );
            }
            await prefs.setString(
              'influencer_username',
              influencerProfile.username,
            );
            await prefs.setBool('is_influencer_onboarded', true);
          }

          // Navigate to influencer dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => InfluencerDashboard()),
          );
          return;
        }
      }
    }

    // If we get here, user is not properly authenticated
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
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
