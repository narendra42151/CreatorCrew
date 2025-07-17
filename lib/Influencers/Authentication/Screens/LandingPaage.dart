import 'package:creatorcrew/Influencers/Authentication/Screens/BLogin.dart';
import 'package:creatorcrew/Influencers/Authentication/Screens/BSignUp.dart';
import 'package:creatorcrew/Influencers/Authentication/Screens/ISignup.dart';
import 'package:creatorcrew/Influencers/Authentication/Screens/InfluencersSignin.dart';
import 'package:flutter/material.dart';

class VaultSyncColors {
  static const primaryColor = Color(0xFF4CAF50);
  static const accentColor = Color(0xFF8BC34A);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF757575);
  static const background = Color(0xFFF5F5F5);
  static const white = Colors.white;
  static const buttonGreen = Color(0xFF4CAF50);
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0; // 0: Brands, 1: Influencers
  bool _showLogin = true; // Toggle between login and signup

  Widget _buildStyledTab(String title, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          _showLogin = true; // Reset to login view when switching tabs
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        height: 45,
        decoration: BoxDecoration(
          color:
              isSelected ? VaultSyncColors.buttonGreen : VaultSyncColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: VaultSyncColors.buttonGreen.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
          border: Border.all(
            color:
                isSelected ? VaultSyncColors.buttonGreen : Colors.grey.shade300,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color:
                isSelected ? VaultSyncColors.white : VaultSyncColors.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VaultSyncColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40),
                Image.asset(
                  'assets/logo.png', // Replace with your actual logo asset
                  height: 70,
                  errorBuilder:
                      (context, error, stackTrace) => Icon(
                        Icons.groups_rounded,
                        size: 70,
                        color: VaultSyncColors.primaryColor,
                      ),
                ),
                SizedBox(height: 20),
                Text(
                  'Creator Crew',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: VaultSyncColors.textDark,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Connect brands with influencers',
                  style: TextStyle(
                    fontSize: 16,
                    color: VaultSyncColors.textLight,
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStyledTab('Brands', 0),
                    SizedBox(width: 16),
                    _buildStyledTab('Influencers', 1),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: VaultSyncColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child:
                      _selectedIndex == 0
                          ? (_showLogin
                              ? BrandLoginWidget(
                                onToggleView:
                                    () => setState(() => _showLogin = false),
                              )
                              : BrandSignupWidget(
                                onToggleView:
                                    () => setState(() => _showLogin = true),
                              ))
                          : (_showLogin
                              ? InfluencerLoginWidget(
                                onToggleView:
                                    () => setState(() => _showLogin = false),
                              )
                              : InfluencerSignupWidget(
                                onToggleView:
                                    () => setState(() => _showLogin = true),
                              )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const CustomTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: VaultSyncColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: VaultSyncColors.textLight),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: VaultSyncColors.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
