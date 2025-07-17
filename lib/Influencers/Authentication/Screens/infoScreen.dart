import 'package:creatorcrew/Influencers/Authentication/Screens/LandingPaage.dart';
import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: VaultSyncColors.buttonGreen,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: VaultSyncColors.buttonGreen,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Account Created Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: VaultSyncColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Please complete your profile to continue.',
                style: TextStyle(
                  fontSize: 16,
                  color: VaultSyncColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Continue to profile setup
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: VaultSyncColors.buttonGreen,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
