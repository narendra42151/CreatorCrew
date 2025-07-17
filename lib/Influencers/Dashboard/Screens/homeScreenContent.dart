import 'dart:math';
import 'dart:ui';

import 'package:creatorcrew/Influencers/Authentication/providers/BrandInfoProvider.dart';
import 'package:creatorcrew/Influencers/Dashboard/Screens/ShineEffect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool hasUnreadNotifications;
  final Function()? onNotificationTap;
  final Function()? onChatTap;
  final Function(String)? onProfileMenuSelect;

  const GlassmorphicAppBar({
    Key? key,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
    this.onChatTap,
    this.onProfileMenuSelect,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    final brandInfoProvider = Provider.of<BrandInfoProvider>(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white.withOpacity(0.2),
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              // Brand Logo
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child:
                      brandInfoProvider.brandInfo?.logoUrl != null
                          ? Image.network(
                            brandInfoProvider.brandInfo!.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.business, color: Colors.grey),
                          )
                          : Icon(Icons.business, color: Colors.grey),
                ),
              ),
              SizedBox(width: 10),

              // Brand Name
              Expanded(
                child: Text(
                  brandInfoProvider.brandInfo?.brandName ?? 'Your Brand',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            // Notification Bell
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.black87,
                    size: 24,
                  ),
                  onPressed: onNotificationTap,
                ),
                if (hasUnreadNotifications)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),

            // Chat Icon
            IconButton(
              icon: Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: onChatTap,
            ),

            // Avatar with Dropdown
            PopupMenuButton(
              offset: Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child:
                      brandInfoProvider.brandInfo?.logoUrl != null
                          ? Image.network(
                            brandInfoProvider.brandInfo!.logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    Icon(Icons.person, color: Colors.grey),
                          )
                          : Icon(Icons.person, color: Colors.grey),
                ),
              ),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Profile'),
                        ],
                      ),
                      value: 'profile',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.settings, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Settings'),
                        ],
                      ),
                      value: 'settings',
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.black54),
                          SizedBox(width: 12),
                          Text('Logout'),
                        ],
                      ),
                      value: 'logout',
                    ),
                  ],
              onSelected: onProfileMenuSelect,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// Example Home Screen Content class that utilizes the GlassmorphicAppBar
class BrandHomeContent extends StatelessWidget {
  const BrandHomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The actual content of your home screen would go here
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 90), // Extra padding for app bar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Banner
          // In the BrandHomeContent class, replace the existing welcome banner with this one

          // Welcome Banner with Animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF4CAF50).withOpacity(0.9),
                    Color(0xFF2E7D32).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4CAF50).withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<BrandInfoProvider>(
                    builder: (context, brandInfoProvider, child) {
                      final brandName =
                          brandInfoProvider.brandInfo?.brandName ??
                          'Your Brand';

                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Hey $brandName Team 👋",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4),
                          // Animated Confetti Emoji
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(seconds: 1),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale:
                                    0.8 +
                                    (value *
                                        0.4 *
                                        (1 + 0.1 * (sin(value * 6.28)))),
                                child: child,
                              );
                            },
                            child: Text("🎉", style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 8),

                  // Performance message with subtle animation
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      "Your latest campaign is outperforming 70% of the brands this week!",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        height: 1.3,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  // Motivational message with shine animation
                  ShineEffect(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              "Keep the momentum going! Schedule your next post.",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Example content sections
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Your Dashboard",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(height: 16),

          // Example card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Start Your First Campaign",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Create a campaign to connect with influencers and grow your brand reach.",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text("Create Campaign"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
