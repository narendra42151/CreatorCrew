import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/InfluencerProfile.dart';
import '../../providers/InfluencerOnboardingProvider.dart';

class PerformanceMetricsStep extends StatefulWidget {
  @override
  _PerformanceMetricsStepState createState() => _PerformanceMetricsStepState();
}

class _PerformanceMetricsStepState extends State<PerformanceMetricsStep> {
  final _formKey = GlobalKey<FormState>();
  final _totalFollowersController = TextEditingController();
  final _engagementRateController = TextEditingController();
  final _avgViewsController = TextEditingController();
  List<String> _pastCampaigns = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<InfluencerOnboardingProvider>(
        context,
        listen: false,
      );
      if (provider.performanceMetrics != null) {
        _totalFollowersController.text =
            provider.performanceMetrics!.totalFollowers.toString();
        _engagementRateController.text =
            provider.performanceMetrics!.averageEngagementRate.toString();
        _avgViewsController.text =
            provider.performanceMetrics!.averageViews?.toString() ?? '';
        _pastCampaigns = List.from(provider.performanceMetrics!.pastCampaigns);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _totalFollowersController.dispose();
    _engagementRateController.dispose();
    _avgViewsController.dispose();
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
                    'Share your performance metrics to help brands find you',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

                  // Total Followers
                  TextFormField(
                    controller: _totalFollowersController,
                    decoration: InputDecoration(
                      labelText: 'Total Followers',
                      hintText: 'Combined followers across all platforms',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateMetrics,
                  ),
                  SizedBox(height: 16),

                  // Average Engagement Rate
                  TextFormField(
                    controller: _engagementRateController,
                    decoration: InputDecoration(
                      labelText: 'Average Engagement Rate (%)',
                      hintText: 'e.g., 5.2',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.trending_up),
                      suffixText: '%',
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    onChanged: _updateMetrics,
                  ),
                  SizedBox(height: 16),

                  // Average Views (for video content)
                  TextFormField(
                    controller: _avgViewsController,
                    decoration: InputDecoration(
                      labelText: 'Average Views (Optional)',
                      hintText: 'For video content',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.play_circle),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: _updateMetrics,
                  ),
                  SizedBox(height: 24),

                  // Past Campaigns Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Past Campaigns (Optional)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addCampaign,
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

                  // Past Campaigns List
                  if (_pastCampaigns.isEmpty)
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
                            Icons.campaign,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'No past campaigns added',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Add campaigns to showcase your experience',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(_pastCampaigns.length, (index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.campaign),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          title: Text(_pastCampaigns[index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeCampaign(index),
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
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info, color: Colors.blue, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Performance metrics help brands understand your reach and engagement. This information will be displayed in your profile.',
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

  void _updateMetrics([String? value]) {
    final provider = Provider.of<InfluencerOnboardingProvider>(
      context,
      listen: false,
    );

    final totalFollowers = int.tryParse(_totalFollowersController.text) ?? 0;
    final engagementRate =
        double.tryParse(_engagementRateController.text) ?? 0.0;
    final avgViews = int.tryParse(_avgViewsController.text);

    if (totalFollowers > 0 ||
        engagementRate > 0 ||
        avgViews != null ||
        _pastCampaigns.isNotEmpty) {
      final metrics = PerformanceMetrics(
        totalFollowers: totalFollowers,
        averageEngagementRate: engagementRate,
        averageViews: avgViews ?? 0,
        pastCampaigns: _pastCampaigns,
      );
      provider.setPerformanceMetrics(metrics);
    }
  }

  void _addCampaign() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Past Campaign'),
          content: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Campaign Name/Brand',
              hintText: 'e.g., Nike Summer Collection 2024',
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
                    _pastCampaigns.add(controller.text);
                  });
                  _updateMetrics();
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

  void _removeCampaign(int index) {
    setState(() {
      _pastCampaigns.removeAt(index);
    });
    _updateMetrics();
  }
}
