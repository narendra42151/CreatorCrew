import 'package:creatorcrew/Influencers/Authentication/Screens/Binfo.dart';
import 'package:creatorcrew/Influencers/Authentication/Screens/LandingPaage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Login-Provider.dart';

class BrandSignupWidget extends StatefulWidget {
  final VoidCallback onToggleView;

  const BrandSignupWidget({required this.onToggleView});

  @override
  _BrandSignupWidgetState createState() => _BrandSignupWidgetState();
}

class _BrandSignupWidgetState extends State<BrandSignupWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    print("Starting signup process");
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      print("Calling auth provider signup");
      final error = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: UserRole.influencer,
        name: _nameController.text.trim(),
      );
      print("Auth signup completed, error: $error");

      if (error != null) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      } else {
        print("Signup successful, attempting navigation");
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BrandInfoForm()),
        );
        print(
          "Navigation called",
        ); // This might not execute if navigation fails
      }
    } catch (e) {
      print("Error in signup: $e");
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Brand Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: VaultSyncColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sign up to get started',
            style: TextStyle(fontSize: 14, color: VaultSyncColors.textLight),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          if (_errorMessage != null)
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            ),
          CustomTextField(
            label: 'Brand Name',
            hint: 'Enter your brand name',
            controller: _nameController,
            prefixIcon: Icons.business_outlined,
            validator:
                (val) =>
                    val == null || val.isEmpty
                        ? 'Brand name is required'
                        : null,
          ),
          SizedBox(height: 20),
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            validator:
                (val) =>
                    val == null || val.isEmpty || !val.contains('@')
                        ? 'Enter a valid email address'
                        : null,
          ),
          SizedBox(height: 20),
          CustomTextField(
            label: 'Password',
            hint: 'Create a password',
            controller: _passwordController,
            obscureText: true,
            prefixIcon: Icons.lock_outline,
            validator:
                (val) =>
                    val == null || val.isEmpty || val.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _isLoading ? null : _signup,
            child:
                _isLoading
                    ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text('Create Account'),
            style: ElevatedButton.styleFrom(
              backgroundColor: VaultSyncColors.buttonGreen,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(color: VaultSyncColors.textLight),
              ),
              TextButton(
                onPressed: widget.onToggleView,
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: VaultSyncColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
