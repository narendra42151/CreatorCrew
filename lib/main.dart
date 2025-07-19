import 'package:creatorcrew/Brand/Authentication/Screens/splashScreen.dart';
import 'package:creatorcrew/Brand/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Brand/Authentication/providers/CloudinaryProvider.dart';
import 'package:creatorcrew/Brand/Authentication/providers/Login-Provider.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/InfluencerDetailProvider.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/MessageProvider.dart';
import 'package:creatorcrew/Brand/Dashboard/provider/campaignProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/AplicationProvider.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CloudinaryProvider()),
        ChangeNotifierProvider(create: (_) => BrandInfoProvider()),
        ChangeNotifierProvider(create: (_) => CampaignProvider()),
        ChangeNotifierProvider(create: (_) => InfluencerOnboardingProvider()),
        ChangeNotifierProvider(create: (_) => ApplicationProvider()),
        ChangeNotifierProvider(create: (_) => InfluencerDetailProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        title: 'CreatorCrew',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0175C2)),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
