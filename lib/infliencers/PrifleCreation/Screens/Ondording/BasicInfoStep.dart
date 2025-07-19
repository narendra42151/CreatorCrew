import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicInfoStep extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
                    'Let\'s start with your basic information',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

                  // Full Name
                  TextFormField(
                    initialValue: provider.fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'Enter your full name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: provider.setFullName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Full name is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Username
                  TextFormField(
                    initialValue: provider.username,
                    decoration: InputDecoration(
                      labelText: 'Username *',
                      hintText: 'e.g., @fashionqueen',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    onChanged: provider.setUsername,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Email (Read-only as it's from signup)
                  TextFormField(
                    initialValue: provider.email,
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 16),

                  // Phone Number
                  TextFormField(
                    initialValue: provider.phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Phone Number *',
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: provider.setPhoneNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Gender
                  DropdownButtonFormField<String>(
                    value: provider.gender,
                    decoration: InputDecoration(
                      labelText: 'Gender (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    items:
                        ['Male', 'Female', 'Other', 'Prefer not to say']
                            .map(
                              (gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              ),
                            )
                            .toList(),
                    onChanged: provider.setGender,
                  ),
                  SizedBox(height: 16),

                  // Date of Birth
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            provider.dateOfBirth ??
                            DateTime.now().subtract(
                              Duration(days: 6570),
                            ), // 18 years ago
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now().subtract(
                          Duration(days: 4745),
                        ), // 13 years ago
                      );
                      if (date != null) {
                        provider.setDateOfBirth(date);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        provider.dateOfBirth != null
                            ? '${provider.dateOfBirth!.day}/${provider.dateOfBirth!.month}/${provider.dateOfBirth!.year}'
                            : 'Select your date of birth',
                        style: TextStyle(
                          color:
                              provider.dateOfBirth != null
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // City
                  TextFormField(
                    initialValue: provider.city,
                    decoration: InputDecoration(
                      labelText: 'City',
                      hintText: 'Enter your city',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    onChanged: provider.setCity,
                  ),
                  SizedBox(height: 16),

                  // Country
                  TextFormField(
                    initialValue: provider.country,
                    decoration: InputDecoration(
                      labelText: 'Country',
                      hintText: 'Enter your country',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.public),
                    ),
                    onChanged: provider.setCountry,
                  ),
                  SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
