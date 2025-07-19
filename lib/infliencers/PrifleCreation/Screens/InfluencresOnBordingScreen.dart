import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/AdditionalInfoStep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/BasicInfoStep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/InfoINfluencers.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/ProfileSteupstep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/SocialMediaStep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/performanceStep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/Screens/Ondording/professionalInStep.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfluencerOnboardingScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialName;

  const InfluencerOnboardingScreen({
    Key? key,
    this.initialEmail,
    this.initialName,
  }) : super(key: key);
  @override
  _InfluencerOnboardingScreenState createState() =>
      _InfluencerOnboardingScreenState();
}

class _InfluencerOnboardingScreenState
    extends State<InfluencerOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InfluencerOnboardingProvider>(
        context,
        listen: false,
      );

      // Initialize with passed data or Firebase user data
      if (widget.initialEmail != null) {
        provider.setEmail(widget.initialEmail!);
      }
      if (widget.initialName != null) {
        provider.setFullName(widget.initialName!);
      }

      // Also initialize with Firebase user data
      provider.initializeWithUserData();
    });
  }

  final List<String> _stepTitles = [
    'Basic Information',
    'Profile Setup',
    'Social Media',
    'Performance Metrics',
    'Professional Info',
    'Additional Details',
  ];

  final List<Widget> _steps = [
    BasicInfoStep(),
    ProfileSetupStep(),
    SocialMediaStep(),
    PerformanceMetricsStep(),
    ProfessionalInfoStep(),
    AdditionalInfoStep(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of ${_steps.length}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '${((_currentStep + 1) / _steps.length * 100).round()}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / _steps.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16),
                Text(
                  _stepTitles[_currentStep],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: _steps,
            ),
          ),
          // Navigation Buttons
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                      child: Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 16),
                Expanded(
                  child: Consumer<InfluencerOnboardingProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton(
                        onPressed:
                            provider.isLoading
                                ? null
                                : () => _handleNext(provider),
                        child:
                            provider.isLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  _currentStep == _steps.length - 1
                                      ? 'Complete'
                                      : 'Next',
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext(InfluencerOnboardingProvider provider) async {
    bool canProceed = false;

    switch (_currentStep) {
      case 0:
        canProceed = provider.validateBasicInfo();
        if (!canProceed) {
          _showError('Please fill in all required basic information');
        }
        break;
      case 1:
        canProceed = provider.validateProfileSetup();
        if (!canProceed) {
          _showError('Please complete your profile setup');
        }
        break;
      case 2:
        canProceed = provider.validateSocialMedia();
        if (!canProceed) {
          _showError('Please add at least one social media account');
        }
        break;
      case 3:
      case 4:
        canProceed = true; // These steps are optional
        break;
      case 5:
        // Final step - save profile
        final success = await provider.saveProfile();
        if (success) {
          _showSuccessAndNavigate();
        } else {
          _showError(provider.errorMessage ?? 'Failed to save profile');
        }
        return;
    }

    if (canProceed && _currentStep < _steps.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile created successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate to main app or dashboard
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Infoinfluencers()),
    );
  }
}
