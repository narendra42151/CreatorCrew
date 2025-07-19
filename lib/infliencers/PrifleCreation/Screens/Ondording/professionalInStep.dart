import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/InfluencerProfile.dart';
import '../../providers/InfluencerOnboardingProvider.dart';

class ProfessionalInfoStep extends StatefulWidget {
  @override
  _ProfessionalInfoStepState createState() => _ProfessionalInfoStepState();
}

class _ProfessionalInfoStepState extends State<ProfessionalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  final _postRateController = TextEditingController();
  final _storyRateController = TextEditingController();
  final _videoRateController = TextEditingController();
  final _reelRateController = TextEditingController();

  List<String> _availability = [];
  List<String> _pastCollaborations = [];

  final List<String> availabilityOptions = [
    'Weekdays',
    'Weekends',
    'Monday-Friday',
    'Saturday-Sunday',
    'Flexible',
    'By Appointment',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InfluencerOnboardingProvider>(
        context,
        listen: false,
      );
      if (provider.professionalInfo != null) {
        final professionalInfo = provider.professionalInfo!;

        // Load rate card data
        if (professionalInfo.rateCard != null) {
          _postRateController.text =
              professionalInfo.rateCard!.postRate?.toString() ?? '';
          _storyRateController.text =
              professionalInfo.rateCard!.storyRate?.toString() ?? '';
          _videoRateController.text =
              professionalInfo.rateCard!.videoRate?.toString() ?? '';
          _reelRateController.text =
              professionalInfo.rateCard!.reelRate?.toString() ?? '';
        }

        // Load availability data
        if (professionalInfo.availability != null) {
          _availability = [];
          if (professionalInfo.availability!.weekdays) {
            _availability.add('Weekdays');
          }
          if (professionalInfo.availability!.weekends) {
            _availability.add('Weekends');
          }
        }

        // Load past collaborations
        _pastCollaborations = List.from(
          professionalInfo.pastCollaborationBrands,
        );
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _postRateController.dispose();
    _storyRateController.dispose();
    _videoRateController.dispose();
    _reelRateController.dispose();
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
                    'Set your professional rates and availability',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

                  // Rate Card Section
                  Text(
                    'Rate Card (₹)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // Post Rate
                  TextFormField(
                    controller: _postRateController,
                    decoration: InputDecoration(
                      labelText: 'Rate per Post',
                      hintText: 'e.g., 5000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateProfessionalInfo,
                  ),
                  SizedBox(height: 16),

                  // Story Rate
                  TextFormField(
                    controller: _storyRateController,
                    decoration: InputDecoration(
                      labelText: 'Rate per Story',
                      hintText: 'e.g., 2000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.circle),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateProfessionalInfo,
                  ),
                  SizedBox(height: 16),

                  // Video Rate
                  TextFormField(
                    controller: _videoRateController,
                    decoration: InputDecoration(
                      labelText: 'Rate per Video',
                      hintText: 'e.g., 15000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.videocam),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateProfessionalInfo,
                  ),
                  SizedBox(height: 16),

                  // Reel Rate
                  TextFormField(
                    controller: _reelRateController,
                    decoration: InputDecoration(
                      labelText: 'Rate per Reel',
                      hintText: 'e.g., 8000',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.play_circle),
                      prefixText: '₹ ',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateProfessionalInfo,
                  ),
                  SizedBox(height: 32),

                  // Availability Section
                  Text(
                    'Availability',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        availabilityOptions.map((option) {
                          final isSelected = _availability.contains(option);
                          return FilterChip(
                            label: Text(option),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _availability.add(option);
                                } else {
                                  _availability.remove(option);
                                }
                              });
                              _updateProfessionalInfo();
                            },
                            selectedColor: Colors.green.shade100,
                            checkmarkColor: Colors.green,
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 32),

                  // Past Collaborations Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Past Collaborations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addCollaboration,
                        icon: Icon(Icons.add, size: 18),
                        label: Text('Add'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Past Collaborations List
                  if (_pastCollaborations.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.handshake,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No collaborations added',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add brands you\'ve worked with to build credibility',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(_pastCollaborations.length, (index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.business),
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          title: Text(_pastCollaborations[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCollaboration(index),
                          ),
                        ),
                      );
                    }),

                  SizedBox(height: 32),

                  // Info Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your rate card helps brands understand your pricing. You can always negotiate rates for specific campaigns.',
                            style: TextStyle(
                              color: Colors.orange.shade700,
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

  void _updateProfessionalInfo([String? value]) {
    final provider = Provider.of<InfluencerOnboardingProvider>(
      context,
      listen: false,
    );

    final postRate = double.tryParse(_postRateController.text);
    final storyRate = double.tryParse(_storyRateController.text);
    final videoRate = double.tryParse(_videoRateController.text);
    final reelRate = double.tryParse(_reelRateController.text);

    // Create rate card if any rate is provided
    RateCard? rateCard;
    if (postRate != null ||
        storyRate != null ||
        videoRate != null ||
        reelRate != null) {
      rateCard = RateCard(
        postRate: postRate,
        storyRate: storyRate,
        videoRate: videoRate,
        reelRate: reelRate,
      );
    }

    // Create availability
    final availability = Availability(
      weekdays:
          _availability.contains('Weekdays') ||
          _availability.contains('Monday-Friday'),
      weekends:
          _availability.contains('Weekends') ||
          _availability.contains('Saturday-Sunday'),
      specificDates: [], // Can be extended for specific date selection
    );

    // Create professional info
    final professionalInfo = ProfessionalInfo(
      rateCard: rateCard,
      availability: availability,
      pastCollaborationBrands: _pastCollaborations,
    );

    provider.setProfessionalInfo(professionalInfo);
  }

  void _addCollaboration() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Brand Collaboration'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Brand Name',
              hintText: 'e.g., Nike, Adidas, Samsung',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _pastCollaborations.add(controller.text);
                  });
                  _updateProfessionalInfo();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeCollaboration(int index) {
    setState(() {
      _pastCollaborations.removeAt(index);
    });
    _updateProfessionalInfo();
  }
}
