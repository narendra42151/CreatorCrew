import 'package:creatorcrew/Influencers/Authentication/Screens/SplashScreen.dart';
import 'package:creatorcrew/Influencers/Dashboard/provider/campaignProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'Influencers/Authentication/providers/CloudinaryProvider.dart';
import 'Influencers/Authentication/providers/Login-Provider.dart';

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
