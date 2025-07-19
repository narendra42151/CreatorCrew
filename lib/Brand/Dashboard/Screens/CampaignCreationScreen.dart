import 'package:creatorcrew/Brand/Dashboard/provider/campaignProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CampaignCreationScreen extends StatefulWidget {
  @override
  _CampaignCreationScreenState createState() => _CampaignCreationScreenState();
}

class _CampaignCreationScreenState extends State<CampaignCreationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _isDraft = false;

  // Basic Info
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedCategory;
  List<String> _selectedPlatforms = [];

  // Timing
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _preferredTime;

  // Influencer Requirements
  RangeValues _followerRange = RangeValues(10000, 50000);
  final _locationController = TextEditingController();
  String? _selectedLanguage;
  final _engagementRateController = TextEditingController();

  // Content Type
  bool _imagePost = false;
  bool _video = false;
  bool _story = false;
  bool _reelShort = false;

  // Budget Details
  final _budgetPerInfluencerController = TextEditingController();
  final _totalBudgetController = TextEditingController();
  String? _selectedPaymentMethod;

  // Attachments
  List<PlatformFile> _attachedFiles = [];

  // Lists for dropdowns
  final List<String> _categories = [
    'Tech',
    'Fashion',
    'Food',
    'Travel',
    'Beauty',
    'Health',
    'Lifestyle',
    'Gaming',
    'Other',
  ];
  final List<String> _platforms = [
    'Instagram',
    'YouTube',
    'X',
    'LinkedIn',
    'TikTok',
    'Facebook',
  ];
  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Other',
  ];
  final List<String> _paymentMethods = [
    'UPI',
    'Bank Transfer',
    'PayPal',
    'Credit Card',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _engagementRateController.dispose();
    _budgetPerInfluencerController.dispose();
    _totalBudgetController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _attachedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File picking failed: ${e.toString()}')),
      );
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Basic Info
        return _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty &&
            _selectedCategory != null &&
            _selectedPlatforms.isNotEmpty;
      case 1: // Timing
        return _startDate != null && _endDate != null;
      case 2: // Influencer Requirements
        return _locationController.text.isNotEmpty && _selectedLanguage != null;
      case 3: // Content Type
        return _imagePost || _video || _story || _reelShort;
      case 4: // Budget Details
        return _budgetPerInfluencerController.text.isNotEmpty &&
            _totalBudgetController.text.isNotEmpty &&
            _selectedPaymentMethod != null;
      default:
        return true;
    }
  }

  void _saveDraft() {
    setState(() {
      _isDraft = true;
    });
    // Save to local storage or database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Campaign draft saved successfully')),
    );
  }

  void _submitCampaign() async {
    if (_formKey.currentState!.validate()) {
      // Here you would implement the actual submission
      // This would typically involve sending the data to your backend API
      final campaignProvider = Provider.of<CampaignProvider>(
        context,
        listen: false,
      );

      try {
        // Show loading indicator
        setState(() {
          _isLoading = true;
        });
        bool success = await campaignProvider.createCampaign(
          _titleController.text,
          _descriptionController.text,
          _selectedCategory!,
          _selectedPlatforms,
          _startDate!,
          _endDate!,
          _preferredTime,
          _followerRange.start,
          _followerRange.end,
          _locationController.text,
          _selectedLanguage!,
          _engagementRateController.text,
          _imagePost,
          _video,
          _story,
          _reelShort,
          _budgetPerInfluencerController.text,
          _totalBudgetController.text,
          _selectedPaymentMethod!,
          _attachedFiles,
        );
        setState(() {
          _isLoading = false;
        });
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Campaign published successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate back to home screen after short delay
          Future.delayed(Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to publish campaign. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isLoading = false;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Campaign published successfully!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     // Navigate back to home screen after short delay
  //     Future.delayed(Duration(seconds: 2), () {
  //       Navigator.pop(context);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Campaign'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            tooltip: 'Save Draft',
            onPressed: _saveDraft,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 5) {
              if (_validateCurrentStep()) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill all required fields')),
                );
              }
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep -= 1;
              });
            }
          },
          onStepTapped: (step) {
            setState(() {
              _currentStep = step;
            });
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  if (_currentStep < 5)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                      child: Text(_currentStep == 4 ? 'Review' : 'Continue'),
                    ),
                  if (_currentStep > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: details.onStepCancel,
                        child: Text('Back'),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Basic Campaign Info
            Step(
              title: Text('Basic Campaign Info'),
              isActive: _currentStep >= 0,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Campaign Title *',
                      hintText: 'e.g., New Year Promo for Smartwatch',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a campaign title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Campaign Description *',
                      hintText: 'Detailed description, goals, brand tone, etc.',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a campaign description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Platforms *', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children:
                        _platforms.map((platform) {
                          bool isSelected = _selectedPlatforms.contains(
                            platform,
                          );
                          return FilterChip(
                            label: Text(platform),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedPlatforms.add(platform);
                                } else {
                                  _selectedPlatforms.remove(platform);
                                }
                              });
                            },
                            selectedColor: Color(0xFF4CAF50).withOpacity(0.2),
                            checkmarkColor: Color(0xFF4CAF50),
                          );
                        }).toList(),
                  ),
                  if (_selectedPlatforms.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select at least one platform',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            // Step 2: Campaign Timing
            Step(
              title: Text('Campaign Timing'),
              isActive: _currentStep >= 1,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start Date
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null && picked != _startDate) {
                        setState(() {
                          _startDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date *',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _startDate != null
                            ? DateFormat('yyyy-MM-dd').format(_startDate!)
                            : 'Select a date',
                        style: TextStyle(
                          color:
                              _startDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // End Date
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate:
                            _endDate ??
                            (_startDate ?? DateTime.now()).add(
                              Duration(days: 7),
                            ),
                        firstDate: _startDate ?? DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null && picked != _endDate) {
                        setState(() {
                          _endDate = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date *',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        _endDate != null
                            ? DateFormat('yyyy-MM-dd').format(_endDate!)
                            : 'Select a date',
                        style: TextStyle(
                          color: _endDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Preferred Posting Time (Optional)
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _preferredTime ?? TimeOfDay.now(),
                      );
                      if (picked != null && picked != _preferredTime) {
                        setState(() {
                          _preferredTime = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Preferred Posting Time (Optional)',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      child: Text(
                        _preferredTime != null
                            ? _preferredTime!.format(context)
                            : 'Select a time (optional)',
                        style: TextStyle(
                          color:
                              _preferredTime != null
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Step 3: Influencer Requirements
            Step(
              title: Text('Influencer Requirements'),
              isActive: _currentStep >= 2,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Follower Range Slider
                  Text(
                    'Follower Range (${_followerRange.start.round()} - ${_followerRange.end.round()})',
                    style: TextStyle(fontSize: 16),
                  ),
                  RangeSlider(
                    values: _followerRange,
                    min: 1000,
                    max: 1000000,
                    divisions: 100,
                    labels: RangeLabels(
                      '${(_followerRange.start / 1000).toStringAsFixed(1)}K',
                      '${(_followerRange.end / 1000).toStringAsFixed(1)}K',
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _followerRange = values;
                      });
                    },
                    activeColor: Color(0xFF4CAF50),
                  ),
                  SizedBox(height: 16),

                  // Location Target
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Location Target *',
                      hintText: 'e.g., India, Global',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Language
                  DropdownButtonFormField<String>(
                    value: _selectedLanguage,
                    decoration: InputDecoration(
                      labelText: 'Language *',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _languages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language,
                            child: Text(language),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a language';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Engagement Rate
                  TextFormField(
                    controller: _engagementRateController,
                    decoration: InputDecoration(
                      labelText: 'Minimum Engagement Rate (%) (Optional)',
                      hintText: 'e.g., 2.5',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                ],
              ),
            ),

            // Step 4: Content Type
            Step(
              title: Text('Content Type'),
              isActive: _currentStep >= 3,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Content Type(s) *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  // Content Type Checkboxes
                  CheckboxListTile(
                    title: Text('Image Post'),
                    value: _imagePost,
                    activeColor: Color(0xFF4CAF50),
                    onChanged: (value) {
                      setState(() {
                        _imagePost = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('Video'),
                    value: _video,
                    activeColor: Color(0xFF4CAF50),
                    onChanged: (value) {
                      setState(() {
                        _video = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('Story'),
                    value: _story,
                    activeColor: Color(0xFF4CAF50),
                    onChanged: (value) {
                      setState(() {
                        _story = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('Reel/Shorts'),
                    value: _reelShort,
                    activeColor: Color(0xFF4CAF50),
                    onChanged: (value) {
                      setState(() {
                        _reelShort = value ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  if (!(_imagePost || _video || _story || _reelShort))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select at least one content type',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            // Step 5: Budget Details
            Step(
              title: Text('Budget & Attachments'),
              isActive: _currentStep >= 4,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Budget per Influencer
                  TextFormField(
                    controller: _budgetPerInfluencerController,
                    decoration: InputDecoration(
                      labelText: 'Budget per Influencer (₹) *',
                      hintText: 'e.g., 5000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a budget amount';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Total Budget
                  TextFormField(
                    controller: _totalBudgetController,
                    decoration: InputDecoration(
                      labelText: 'Total Budget (₹) *',
                      hintText: 'e.g., 50000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total budget';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Payment Method
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      labelText: 'Payment Method *',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _paymentMethods.map((method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a payment method';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Attachments Section
                  Text(
                    'Attachments (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),

                  ElevatedButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: Text('Add Attachments'),
                    onPressed: _pickFiles,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Show selected files
                  if (_attachedFiles.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _attachedFiles.length,
                      itemBuilder: (context, index) {
                        final file = _attachedFiles[index];
                        return ListTile(
                          leading: Icon(
                            file.extension == 'pdf'
                                ? Icons.picture_as_pdf
                                : file.extension == 'doc' ||
                                    file.extension == 'docx'
                                ? Icons.description
                                : Icons.image,
                            color:
                                file.extension == 'pdf'
                                    ? Colors.red
                                    : file.extension == 'doc' ||
                                        file.extension == 'docx'
                                    ? Colors.blue
                                    : Colors.green,
                          ),
                          title: Text(file.name),
                          subtitle: Text(
                            '${(file.size / 1024).toStringAsFixed(1)} KB',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _removeAttachment(index),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            // Step 6: Preview & Submit
            Step(
              title: Text('Preview & Submit'),
              isActive: _currentStep >= 5,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campaign Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  _buildSummaryItem('Campaign Title', _titleController.text),
                  _buildSummaryItem('Category', _selectedCategory ?? '-'),
                  _buildSummaryItem('Platforms', _selectedPlatforms.join(', ')),
                  _buildSummaryItem(
                    'Duration',
                    _startDate != null && _endDate != null
                        ? '${DateFormat('MMM dd, yyyy').format(_startDate!)} - ${DateFormat('MMM dd, yyyy').format(_endDate!)}'
                        : '-',
                  ),
                  _buildSummaryItem(
                    'Follower Range',
                    '${(_followerRange.start / 1000).toStringAsFixed(1)}K - ${(_followerRange.end / 1000).toStringAsFixed(1)}K',
                  ),
                  _buildSummaryItem('Location', _locationController.text),
                  _buildSummaryItem(
                    'Content Types',
                    [
                      if (_imagePost) 'Image Post',
                      if (_video) 'Video',
                      if (_story) 'Story',
                      if (_reelShort) 'Reel/Shorts',
                    ].join(', '),
                  ),
                  _buildSummaryItem(
                    'Budget per Influencer',
                    '₹${_budgetPerInfluencerController.text}',
                  ),
                  _buildSummaryItem(
                    'Total Budget',
                    '₹${_totalBudgetController.text}',
                  ),

                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitCampaign,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Publish Campaign',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Divider(),
        ],
      ),
    );
  }
}
