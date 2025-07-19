import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSetupStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Consumer<InfluencerOnboardingProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set up your profile to attract brands',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 24),

                // Profile Picture
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: provider.pickProfileImage,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child:
                              provider.profileImage != null
                                  ? ClipOval(
                                    child: Image.file(
                                      provider.profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : provider.profileImageUrl != null
                                  ? ClipOval(
                                    child: Image.network(
                                      provider.profileImageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add profile picture',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),

                // Bio
                TextFormField(
                  initialValue: provider.bio,
                  decoration: InputDecoration(
                    labelText: 'Bio *',
                    hintText: 'e.g., "Tech reviewer with 300k+ YT subs"',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: 200,
                  onChanged: provider.setBio,
                ),
                SizedBox(height: 24),

                // Categories
                Text(
                  'Categories/Niches *',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Select the categories that best describe your content',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      provider.availableCategories.map((category) {
                        final isSelected = provider.selectedCategories.contains(
                          category,
                        );
                        return FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            provider.toggleCategory(category);
                          },
                          selectedColor: Colors.blue.shade100,
                          checkmarkColor: Colors.blue,
                        );
                      }).toList(),
                ),
                SizedBox(height: 24),

                // Languages
                Text(
                  'Languages Spoken',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Select languages you can create content in',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      provider.availableLanguages.map((language) {
                        final isSelected = provider.selectedLanguages.contains(
                          language,
                        );
                        return FilterChip(
                          label: Text(language),
                          selected: isSelected,
                          onSelected: (selected) {
                            provider.toggleLanguage(language);
                          },
                          selectedColor: Colors.green.shade100,
                          checkmarkColor: Colors.green,
                        );
                      }).toList(),
                ),
                SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
