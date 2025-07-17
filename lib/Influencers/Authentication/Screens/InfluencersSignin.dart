import 'package:creatorcrew/Influencers/Authentication/Screens/LandingPaage.dart';
import 'package:creatorcrew/Influencers/Authentication/providers/Login-Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfluencerLoginWidget extends StatefulWidget {
  final VoidCallback onToggleView;

  const InfluencerLoginWidget({required this.onToggleView});

  @override
  _InfluencerLoginWidgetState createState() => _InfluencerLoginWidgetState();
}

class _InfluencerLoginWidgetState extends State<InfluencerLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final error = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: UserRole.influencer,
      );

      if (error != null) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final error = await authProvider.signInWithGoogle(UserRole.influencer);

      if (error != null) {
        setState(() {
          _errorMessage = error;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email address first";
      });
      return;
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final error = await authProvider.forgotPassword(
        _emailController.text.trim(),
      );

      if (error != null) {
        setState(() => _errorMessage = error);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Password reset email sent!')));
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
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
            'Welcome Back, Influencer!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: VaultSyncColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Sign in to continue',
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
            hint: 'Enter your password',
            controller: _passwordController,
            obscureText: true,
            prefixIcon: Icons.lock_outline,
            validator:
                (val) =>
                    val == null || val.isEmpty || val.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: VaultSyncColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : _login,
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
                    : Text('Sign In'),
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
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: VaultSyncColors.textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: 20),
          OutlinedButton.icon(
            icon: Image.asset(
              'assets/google_logo.png',
              height: 24,
              width: 24,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.g_mobiledata, color: VaultSyncColors.textDark),
            ),
            label: Text(
              'Sign in with Google',
              style: TextStyle(
                color: VaultSyncColors.textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: _isLoading ? null : _loginWithGoogle,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(color: VaultSyncColors.textLight),
              ),
              TextButton(
                onPressed: widget.onToggleView,
                child: Text(
                  'Sign Up',
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
