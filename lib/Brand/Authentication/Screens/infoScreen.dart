import 'package:creatorcrew/Brand/Authentication/Screens/LandingPaage.dart';
import 'package:creatorcrew/Brand/Dashboard/Screens/BDashboard.dart';
import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultSyncColors.background,
      appBar: AppBar(),

      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                // First onboarding screen
                SingleChildScrollView(
                  child: OnboardingPage(
                    image: 'assets/i1.jpg',
                    title: 'Connect. Collaborate. Create.',
                    description:
                        'Build real relationships between influencers and brands — simplified, secure, and seamless.',
                    showArrow: true,
                    onArrowTap: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),

                // Second onboarding screen
                OnboardingPage(
                  image: 'assets/i2.jpg',
                  title: 'Everything You Need — In One Place.',
                  description:
                      'From pitches to partnerships, manage your collaborations smoothly right inside the app.',
                  showArrow: false,
                  onArrowTap: null,
                ),
              ],
            ),
          ),

          // Page indicator and button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              children: [
                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Navigate to main app when finished with onboarding
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BrandHomeNav(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: VaultSyncColors.buttonGreen,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage < 1 ? 'Next' : 'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(bool isActive) {
    return Container(
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? VaultSyncColors.buttonGreen : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool showArrow;
  final VoidCallback? onArrowTap;

  const OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    this.showArrow = false,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            image,
            height: MediaQuery.of(context).size.height * 0.4,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
          ),
          SizedBox(height: 40),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: VaultSyncColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: VaultSyncColors.textLight,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Arrow to swipe
          if (showArrow) ...[
            SizedBox(height: 40),
            GestureDetector(
              onTap: onArrowTap,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: VaultSyncColors.buttonGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: VaultSyncColors.buttonGreen,
                  size: 28,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
