import 'dart:io';

import 'package:creatorcrew/Influencers/Authentication/Models/BrandModel.dart';
import 'package:creatorcrew/Influencers/Authentication/Screens/infoScreen.dart';
import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'LandingPaage.dart';

class BrandInfoForm extends StatefulWidget {
  @override
  _BrandInfoFormState createState() => _BrandInfoFormState();
}

class _BrandInfoFormState extends State<BrandInfoForm> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  File? _logoFile;
  final ImagePicker _picker = ImagePicker();

  // Basic Info
  final _brandNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _websiteController = TextEditingController();

  // Company Profile
  final _companyDescriptionController = TextEditingController();
  String _industryType = 'Fashion';
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  String _companySize = '1-10';

  // Social Media
  final _instagramController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _twitterController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _facebookController = TextEditingController();

  // Marketing Preferences
  final List<String> _selectedInfluencerCategories = [];
  Map<String, bool> _audienceAgeRange = {
    '13-17': false,
    '18-24': false,
    '25-34': false,
    '35-44': false,
    '45+': false,
  };
  List<String> _targetLocations = [];
  String _budgetRange = '\$1,000-\$5,000';
  final List<String> _selectedCampaignGoals = [];

  List<String> industryTypes = [
    'Fashion',
    'Tech',
    'Food',
    'Fitness',
    'Beauty',
    'Travel',
    'Entertainment',
    'Gaming',
    'Education',
    'Health',
    'Finance',
    'Automotive',
    'Home & Decor',
    'Pets',
    'Sports',
    'Other',
  ];

  List<String> companySizes = ['1-10', '11-50', '51-200', '201-500', '500+'];

  List<String> budgetRanges = [
    'Under \$1,000',
    '\$1,000-\$5,000',
    '\$5,001-\$10,000',
    '\$10,001-\$25,000',
    '\$25,001-\$50,000',
    '\$50,001+',
  ];

  Map<String, bool> influencerCategories = {
    'Fashion': false,
    'Beauty': false,
    'Lifestyle': false,
    'Fitness': false,
    'Travel': false,
    'Food': false,
    'Tech': false,
    'Gaming': false,
    'Business': false,
    'Education': false,
    'Entertainment': false,
    'Family & Parenting': false,
    'Pets': false,
    'Sports': false,
    'Arts & Crafts': false,
  };

  Map<String, bool> campaignGoals = {
    'Brand Awareness': false,
    'Product Launch': false,
    'App Installs': false,
    'Website Traffic': false,
    'Lead Generation': false,
    'Sales Conversion': false,
    'User-Generated Content': false,
    'Social Media Growth': false,
    'Product Reviews': false,
    'Community Building': false,
  };

  @override
  void dispose() {
    _brandNameController.dispose();
    _contactPersonController.dispose();
    _contactNumberController.dispose();
    _websiteController.dispose();
    _companyDescriptionController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _instagramController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    _youtubeController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final brandInfoProvider = Provider.of<BrandInfoProvider>(
        context,
        listen: false,
      );

      // Get selected influencer categories
      _selectedInfluencerCategories.clear();
      influencerCategories.forEach((key, value) {
        if (value) _selectedInfluencerCategories.add(key);
      });

      // Get selected campaign goals
      _selectedCampaignGoals.clear();
      campaignGoals.forEach((key, value) {
        if (value) _selectedCampaignGoals.add(key);
      });

      // Get selected audience age ranges
      List<String> selectedAgeRanges = [];
      _audienceAgeRange.forEach((key, value) {
        if (value) selectedAgeRanges.add(key);
      });

      // Create brand model
      final brandModel = BrandModel(
        brandName: _brandNameController.text,
        contactPerson: _contactPersonController.text,
        contactNumber: _contactNumberController.text,
        website: _websiteController.text,
        email: '', // Will be set by provider
        description: _companyDescriptionController.text,
        industryType: _industryType,
        location: LocationModel(
          country: _countryController.text,
          city: _cityController.text,
          address: _addressController.text,
        ),
        companySize: _companySize,
        socialMedia: SocialMediaModel(
          instagram: _instagramController.text,
          linkedin: _linkedinController.text,
          twitter: _twitterController.text,
          youtube: _youtubeController.text,
          facebook: _facebookController.text,
        ),
        marketingPreferences: MarketingPreferencesModel(
          influencerCategories: _selectedInfluencerCategories,
          audienceAgeRanges: selectedAgeRanges,
          targetLocations: _targetLocations,
          budgetRange: _budgetRange,
          campaignGoals: _selectedCampaignGoals,
        ),
      );

      // Save brand info to Firestore via provider
      final success = await brandInfoProvider.saveBrandInfo(
        brandModel,
        logoFile: _logoFile,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brand profile created successfully!')),
        );

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Info()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating brand profile. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brandInfoProvider = Provider.of<BrandInfoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Brand Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4CAF50), // A vibrant green
                Color(0xFF2E7D32), // Deeper green for depth
              ],
            ),
          ),
        ),
      ),
      body:
          brandInfoProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : Stepper(
                type: StepperType.vertical,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep < 3) {
                    setState(() {
                      _currentStep += 1;
                    });
                  } else {
                    _submitForm();
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  return Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: VaultSyncColors.buttonGreen,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              _currentStep < 3 ? 'Continue' : 'Submit',
                            ),
                          ),
                        ),
                        if (_currentStep > 0) ...[
                          SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: details.onStepCancel,
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text('Back'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 1: Basic Brand Information
                  Step(
                    title: Text('Basic Info'),
                    isActive: _currentStep >= 0,
                    content: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                            label: 'Brand Name',
                            hint: 'Enter your brand name',
                            controller: _brandNameController,
                            prefixIcon: Icons.business,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Brand name is required'
                                        : null,
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            label: 'Contact Person Name',
                            hint: 'Enter contact person\'s name',
                            controller: _contactPersonController,
                            prefixIcon: Icons.person,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Contact person name is required'
                                        : null,
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            label: 'Contact Number',
                            hint: 'Enter contact phone number',
                            controller: _contactNumberController,
                            prefixIcon: Icons.phone,
                            validator:
                                (val) =>
                                    val == null || val.isEmpty
                                        ? 'Contact number is required'
                                        : null,
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            label: 'Official Website (Optional)',
                            hint: 'https://yourbrand.com',
                            controller: _websiteController,
                            prefixIcon: Icons.web,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Step 2: Company Profile
                  Step(
                    title: Text('Company'),
                    isActive: _currentStep >= 1,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo Upload
                        Text(
                          'Company Logo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child:
                                _logoFile != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.file(
                                        _logoFile!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 40,
                                          color: Colors.grey.shade400,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload Logo',
                                          style: TextStyle(
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Company Description
                        Text(
                          'Company Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _companyDescriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Brief introduction about your brand',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                          validator:
                              (val) =>
                                  val == null || val.isEmpty
                                      ? 'Company description is required'
                                      : null,
                        ),
                        SizedBox(height: 16),

                        // Industry Type
                        Text(
                          'Industry Type',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _industryType,
                              isExpanded: true,
                              items:
                                  industryTypes.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _industryType = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Location
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _countryController,
                                decoration: InputDecoration(
                                  hintText: 'Country',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                  hintText: 'City',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            hintText: 'Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Company Size
                        Text(
                          'Company Size',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _companySize,
                              isExpanded: true,
                              items:
                                  companySizes.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text('$value employees'),
                                    );
                                  }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _companySize = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Step 3: Social Media Links
                  Step(
                    title: Text('Social'),
                    isActive: _currentStep >= 2,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Social Media Links',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: VaultSyncColors.textDark,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Instagram
                        SocialMediaField(
                          controller: _instagramController,
                          iconData: Icons.camera_alt,
                          iconColor: Color(0xFFE1306C),
                          label: 'Instagram Profile',
                          hint: 'instagram.com/yourbrand',
                        ),
                        SizedBox(height: 16),

                        // LinkedIn
                        SocialMediaField(
                          controller: _linkedinController,
                          iconData: Icons.business_center,
                          iconColor: Color(0xFF0077B5),
                          label: 'LinkedIn Profile',
                          hint: 'linkedin.com/company/yourbrand',
                        ),
                        SizedBox(height: 16),

                        // Twitter
                        SocialMediaField(
                          controller: _twitterController,
                          iconData: Icons.chat_bubble_outline,
                          iconColor: Color(0xFF1DA1F2),
                          label: 'Twitter Profile',
                          hint: 'twitter.com/yourbrand',
                        ),
                        SizedBox(height: 16),

                        // YouTube
                        SocialMediaField(
                          controller: _youtubeController,
                          iconData: Icons.play_arrow,
                          iconColor: Color(0xFFFF0000),
                          label: 'YouTube Channel',
                          hint: 'youtube.com/c/yourbrand',
                        ),
                        SizedBox(height: 16),

                        // Facebook
                        SocialMediaField(
                          controller: _facebookController,
                          iconData: Icons.thumb_up,
                          iconColor: Color(0xFF1877F2),
                          label: 'Facebook Page',
                          hint: 'facebook.com/yourbrand',
                        ),
                      ],
                    ),
                  ),

                  // Step 4: Marketing & Campaign Preferences
                  Step(
                    title: Text('Marketing'),
                    isActive: _currentStep >= 3,
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Marketing & Campaign Preferences',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Preferred Influencer Categories
                          Text(
                            'Preferred Influencer Categories',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                influencerCategories.keys.map((
                                  String category,
                                ) {
                                  return FilterChip(
                                    label: Text(category),
                                    selected: influencerCategories[category]!,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        influencerCategories[category] =
                                            selected;
                                      });
                                    },
                                    selectedColor: VaultSyncColors.accentColor
                                        .withOpacity(0.3),
                                    checkmarkColor: VaultSyncColors.buttonGreen,
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 24),

                          // Target Audience - Age Range
                          Text(
                            'Target Audience - Age Range',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                _audienceAgeRange.keys.map((String age) {
                                  return FilterChip(
                                    label: Text(age),
                                    selected: _audienceAgeRange[age]!,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _audienceAgeRange[age] = selected;
                                      });
                                    },
                                    selectedColor: VaultSyncColors.accentColor
                                        .withOpacity(0.3),
                                    checkmarkColor: VaultSyncColors.buttonGreen,
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 24),

                          // Target Locations
                          Text(
                            'Target Locations (Optional)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          ChipInput(
                            onChanged: (tags) {
                              _targetLocations = tags;
                            },
                            hint: 'Add location and press enter',
                          ),
                          SizedBox(height: 24),

                          // Budget Range
                          Text(
                            'Budget Range (Per Campaign)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _budgetRange,
                                isExpanded: true,
                                items:
                                    budgetRanges.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _budgetRange = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Campaign Goals
                          Text(
                            'Campaign Goals',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: VaultSyncColors.textDark,
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                campaignGoals.keys.map((String goal) {
                                  return FilterChip(
                                    label: Text(goal),
                                    selected: campaignGoals[goal]!,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        campaignGoals[goal] = selected;
                                      });
                                    },
                                    selectedColor: VaultSyncColors.accentColor
                                        .withOpacity(0.3),
                                    checkmarkColor: VaultSyncColors.buttonGreen,
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class SocialMediaField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final Color iconColor;
  final String label;
  final String hint;

  const SocialMediaField({
    required this.controller,
    required this.iconData,
    required this.iconColor,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: iconColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChipInput extends StatefulWidget {
  final Function(List<String>) onChanged;
  final String hint;

  const ChipInput({required this.onChanged, required this.hint});

  @override
  _ChipInputState createState() => _ChipInputState();
}

class _ChipInputState extends State<ChipInput> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _tags = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    tag = tag.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _controller.clear();
      });
      widget.onChanged(_tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _addTag(_controller.text);
              },
            ),
          ),
          onSubmitted: _addTag,
        ),
        if (_tags.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                        widget.onChanged(_tags);
                      },
                      backgroundColor: VaultSyncColors.accentColor.withOpacity(
                        0.2,
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }
}
