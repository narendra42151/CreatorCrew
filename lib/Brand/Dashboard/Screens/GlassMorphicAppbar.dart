import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlassmorphicAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool hasUnreadNotifications;
  final Function()? onNotificationTap;
  final Function()? onChatTap;
  final Function(String)? onProfileMenuSelect;
  final Function()? onbookmarkoutlinetap;

  const GlassmorphicAppBar({
    Key? key,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
    this.onChatTap,
    this.onProfileMenuSelect,
    this.onbookmarkoutlinetap,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  _GlassmorphicAppBarState createState() => _GlassmorphicAppBarState();
}

class _GlassmorphicAppBarState extends State<GlassmorphicAppBar> {
  String? brandName;
  String? logoUrl;

  @override
  void initState() {
    super.initState();
    _loadBrandData();
  }

  Future<void> _loadBrandData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      brandName = prefs.getString('brand_name');
      logoUrl = prefs.getString('brand_logo_url');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      logoUrl != null
                          ? Image.network(
                            logoUrl!,
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
                  brandName ?? 'Your Brand',
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
                  onPressed: widget.onNotificationTap,
                ),
                if (widget.hasUnreadNotifications)
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
              onPressed: widget.onChatTap,
            ),
            IconButton(
              icon: Icon(Icons.bookmark_add, color: Colors.black87, size: 24),
              onPressed: widget.onbookmarkoutlinetap,
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
                      logoUrl != null
                          ? Image.network(
                            logoUrl!,
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
              onSelected: widget.onProfileMenuSelect,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
