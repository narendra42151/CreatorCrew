import 'package:creatorcrew/infliencers/PrifleCreation/Models/InfluencerProfile.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Remove these duplicate/incorrect imports:
// import '../../providers/influencer_onboarding_provider.dart';
// import '../../models/influencer_model.dart';

class SocialMediaStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Consumer<InfluencerOnboardingProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Connect your social media accounts',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),

              // Add Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddAccountDialog(context, provider),
                  icon: Icon(Icons.add),
                  label: Text('Add Social Media Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Social Media Accounts List
              Expanded(
                child:
                    provider.socialMediaAccounts.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.social_distance,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No social media accounts added yet',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add at least one account to continue',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: provider.socialMediaAccounts.length,
                          itemBuilder: (context, index) {
                            final account = provider.socialMediaAccounts[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(
                                    _getPlatformIcon(account.platform),
                                  ),
                                  backgroundColor: _getPlatformColor(
                                    account.platform,
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(account.platform),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('@${account.username}'),
                                    Text(
                                      '${_formatNumber(account.followerCount)} followers',
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed:
                                          () => _showEditAccountDialog(
                                            context,
                                            provider,
                                            index,
                                            account,
                                          ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => provider
                                              .removeSocialMediaAccount(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddAccountDialog(
    BuildContext context,
    InfluencerOnboardingProvider provider,
  ) {
    _showAccountDialog(context, provider, null, null);
  }

  void _showEditAccountDialog(
    BuildContext context,
    InfluencerOnboardingProvider provider,
    int index,
    SocialMediaAccount account,
  ) {
    _showAccountDialog(context, provider, index, account);
  }

  void _showAccountDialog(
    BuildContext context,
    InfluencerOnboardingProvider provider,
    int? index,
    SocialMediaAccount? existingAccount,
  ) {
    final _formKey = GlobalKey<FormState>();
    String selectedPlatform =
        existingAccount?.platform ?? provider.socialMediaPlatforms.first;
    String username = existingAccount?.username ?? '';
    String followerCount = existingAccount?.followerCount.toString() ?? '';
    String engagementRate = existingAccount?.engagementRate?.toString() ?? '';
    String avgViews = existingAccount?.avgViews?.toString() ?? '';
    String channelLink = existingAccount?.channelLink ?? '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              index != null ? 'Edit Account' : 'Add Social Media Account',
            ),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Platform Selection
                    DropdownButtonFormField<String>(
                      value: selectedPlatform,
                      decoration: InputDecoration(
                        labelText: 'Platform',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          provider.socialMediaPlatforms.map((platform) {
                            return DropdownMenuItem(
                              value: platform,
                              child: Text(platform),
                            );
                          }).toList(),
                      onChanged: (value) {
                        selectedPlatform = value!;
                      },
                    ),
                    SizedBox(height: 16),

                    // Username
                    TextFormField(
                      initialValue: username,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter username without @',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => username = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Follower Count
                    TextFormField(
                      initialValue: followerCount,
                      decoration: InputDecoration(
                        labelText: 'Follower Count',
                        hintText: 'e.g., 10000',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => followerCount = value,
                    ),
                    SizedBox(height: 16),

                    // Engagement Rate
                    TextFormField(
                      initialValue: engagementRate,
                      decoration: InputDecoration(
                        labelText: 'Engagement Rate (%)',
                        hintText: 'e.g., 5.2',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (value) => engagementRate = value,
                    ),
                    SizedBox(height: 16),

                    // Average Views (for video platforms)
                    if (['YouTube', 'TikTok'].contains(selectedPlatform))
                      Column(
                        children: [
                          TextFormField(
                            initialValue: avgViews,
                            decoration: InputDecoration(
                              labelText: 'Average Views',
                              hintText: 'e.g., 50000',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => avgViews = value,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),

                    // Channel Link (for YouTube)
                    if (selectedPlatform == 'YouTube')
                      Column(
                        children: [
                          TextFormField(
                            initialValue: channelLink,
                            decoration: InputDecoration(
                              labelText: 'Channel Link',
                              hintText: 'https://youtube.com/channel/...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => channelLink = value,
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final account = SocialMediaAccount(
                      platform: selectedPlatform,
                      username: username,
                      followerCount:
                          followerCount.isNotEmpty
                              ? int.tryParse(followerCount) ?? 0
                              : 0,
                      engagementRate:
                          engagementRate.isNotEmpty
                              ? double.tryParse(engagementRate)
                              : null,
                      avgViews:
                          avgViews.isNotEmpty ? int.tryParse(avgViews) : null,
                      channelLink: channelLink.isNotEmpty ? channelLink : null,
                    );

                    if (index != null) {
                      provider.updateSocialMediaAccount(index, account);
                    } else {
                      provider.addSocialMediaAccount(account);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(index != null ? 'Update' : 'Add'),
              ),
            ],
          ),
    );
  }

  IconData _getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Icons.camera_alt;
      case 'youtube':
        return Icons.play_circle;
      case 'tiktok':
        return Icons.music_note;
      case 'twitter/x':
        return Icons.chat;
      case 'snapchat':
        return Icons.camera;
      case 'linkedin':
        return Icons.work;
      case 'facebook':
        return Icons.facebook;
      default:
        return Icons.public;
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'instagram':
        return Colors.purple;
      case 'youtube':
        return Colors.red;
      case 'tiktok':
        return Colors.black;
      case 'twitter/x':
        return Colors.blue;
      case 'snapchat':
        return Colors.yellow.shade700;
      case 'linkedin':
        return Colors.blue.shade800;
      case 'facebook':
        return Colors.blue.shade600;
      default:
        return Colors.grey;
    }
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }
}
