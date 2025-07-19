import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/InfluencerProfile.dart';
import '../../providers/InfluencerOnboardingProvider.dart';

class AdditionalInfoStep extends StatefulWidget {
  @override
  _AdditionalInfoStepState createState() => _AdditionalInfoStepState();
}

class _AdditionalInfoStepState extends State<AdditionalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _gstController = TextEditingController();
  final _panController = TextEditingController();
  final _referralController = TextEditingController();

  String? _selectedPaymentMethod;

  final List<String> paymentMethods = [
    'UPI',
    'Bank Transfer',
    'PayPal',
    'Paytm',
    'PhonePe',
    'Google Pay',
    'Cheque',
    'Cash',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InfluencerOnboardingProvider>(
        context,
        listen: false,
      );
      if (provider.additionalInfo != null) {
        _gstController.text = provider.additionalInfo!.gstNumber ?? '';
        _panController.text = provider.additionalInfo!.panNumber ?? '';
        _referralController.text = provider.additionalInfo!.referralCode ?? '';
        _selectedPaymentMethod = provider.additionalInfo!.paymentMethod;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _gstController.dispose();
    _panController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Consumer<InfluencerOnboardingProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional information for payments and verification',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

                  // Payment Method Section
                  Text(
                    'Preferred Payment Method',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 9),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Payment Method',
                      hintText: 'Select your preferred payment method',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items:
                        paymentMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Row(
                              children: [
                                Icon(_getPaymentIcon(method), size: 12),
                                SizedBox(width: 8),
                                Text(method),
                              ],
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                      _updateAdditionalInfo();
                    },
                  ),
                  SizedBox(height: 30),

                  // Tax Information Section (for Indian users)
                  Text(
                    'Tax Information (India)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Required for payments above ₹50,000 annually',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),

                  // GST Number
                  TextFormField(
                    controller: _gstController,
                    decoration: InputDecoration(
                      labelText: 'GST Number (Optional)',
                      hintText: 'e.g., 07AADCA1234M1ZN',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.receipt_long),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: _updateAdditionalInfo,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != 15) {
                          return 'GST number should be 15 characters long';
                        }
                        if (!RegExp(
                          r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid GST number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // PAN Number
                  TextFormField(
                    controller: _panController,
                    decoration: InputDecoration(
                      labelText: 'PAN Number (Optional)',
                      hintText: 'e.g., ABCDE1234F',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.credit_card),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: _updateAdditionalInfo,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != 10) {
                          return 'PAN number should be 10 characters long';
                        }
                        if (!RegExp(
                          r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid PAN number';
                        }
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),

                  // Referral Section
                  Text(
                    'Referral Code',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Enter a referral code if you have one',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _referralController,
                    decoration: InputDecoration(
                      labelText: 'Referral Code (Optional)',
                      hintText: 'e.g., CREATOR2024',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.redeem),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: _updateAdditionalInfo,
                  ),
                  SizedBox(height: 32),

                  // Benefits Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.green,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Benefits of completing your profile',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ...benefits
                            .map(
                              (benefit) => Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        benefit,
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Privacy Notice
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.security, color: Colors.blue, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your personal information is encrypted and stored securely. Tax information is only used for payment processing and compliance.',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  final List<String> benefits = [
    'Higher visibility to premium brands',
    'Faster payment processing',
    'Priority customer support',
    'Access to exclusive campaigns',
    'Professional profile badge',
  ];

  void _updateAdditionalInfo([String? value]) {
    final provider = Provider.of<InfluencerOnboardingProvider>(
      context,
      listen: false,
    );

    if (_selectedPaymentMethod != null ||
        _gstController.text.isNotEmpty ||
        _panController.text.isNotEmpty ||
        _referralController.text.isNotEmpty) {
      final additionalInfo = AdditionalInfo(
        gstNumber: _gstController.text.isNotEmpty ? _gstController.text : null,
        panNumber: _panController.text.isNotEmpty ? _panController.text : null,
        paymentMethod: _selectedPaymentMethod,
        referralCode:
            _referralController.text.isNotEmpty
                ? _referralController.text
                : null,
      );

      provider.setAdditionalInfo(additionalInfo);
    }
  }

  IconData _getPaymentIcon(String method) {
    switch (method.toLowerCase()) {
      case 'upi':
        return Icons.qr_code;
      case 'bank transfer':
        return Icons.account_balance;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'paytm':
      case 'phonepe':
      case 'google pay':
        return Icons.smartphone;
      case 'cheque':
        return Icons.receipt;
      case 'cash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }
}
