// // import 'dart:ui';

// // import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // class InfluencerGlassmorphicAppBar extends StatefulWidget
// //     implements PreferredSizeWidget {
// //   final String currentPageTitle;
// //   final bool hasUnreadNotifications;
// //   final Function()? onNotificationTap;
// //   final Function()? onChatTap;
// //   final Function(String)? onProfileMenuSelect;

// //   const InfluencerGlassmorphicAppBar({
// //     Key? key,
// //     required this.currentPageTitle,
// //     this.hasUnreadNotifications = false,
// //     this.onNotificationTap,
// //     this.onChatTap,
// //     this.onProfileMenuSelect,
// //   }) : super(key: key);

// //   @override
// //   Size get preferredSize => Size.fromHeight(70.0);

// //   @override
// //   _InfluencerGlassmorphicAppBarState createState() =>
// //       _InfluencerGlassmorphicAppBarState();
// // }

// // class _InfluencerGlassmorphicAppBarState
// //     extends State<InfluencerGlassmorphicAppBar> {
// //   String? influencerName;
// //   String? profileUrl;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadInfluencerData();
// //   }

// //   Future<void> _loadInfluencerData() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     setState(() {
// //       influencerName = prefs.getString('influencer_name');
// //       profileUrl = prefs.getString('influencer_profile_url');
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return ClipRRect(
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //         child: AppBar(
// //           systemOverlayStyle: SystemUiOverlayStyle(
// //             statusBarColor: Colors.transparent,
// //             statusBarIconBrightness: Brightness.dark,
// //           ),
// //           backgroundColor: Colors.white.withOpacity(0.2),
// //           elevation: 0,
// //           flexibleSpace: Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 colors: [
// //                   Colors.white.withOpacity(0.5),
// //                   Colors.white.withOpacity(0.2),
// //                 ],
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //               ),
// //               border: Border(
// //                 bottom: BorderSide(
// //                   color: Colors.white.withOpacity(0.2),
// //                   width: 1.5,
// //                 ),
// //               ),
// //             ),
// //           ),
// //           title: Consumer<InfluencerOnboardingProvider>(
// //             builder: (context, provider, child) {
// //               return Row(
// //                 children: [
// //                   // Profile Avatar
// //                   Container(
// //                     height: 40,
// //                     width: 40,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.white,
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.1),
// //                           blurRadius: 8,
// //                           offset: Offset(0, 2),
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(20),
// //                       child:
// //                           provider.profileImageUrl != null || profileUrl != null
// //                               ? Image.network(
// //                                 provider.profileImageUrl ?? profileUrl!,
// //                                 fit: BoxFit.cover,
// //                                 errorBuilder:
// //                                     (context, error, stackTrace) =>
// //                                         Icon(Icons.person, color: Colors.grey),
// //                               )
// //                               : Icon(Icons.person, color: Colors.grey),
// //                     ),
// //                   ),
// //                   SizedBox(width: 10),

// //                   // Welcome Text and Name
// //                   Expanded(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           widget.currentPageTitle,
// //                           style: TextStyle(
// //                             color: Colors.black87,
// //                             fontWeight: FontWeight.w600,
// //                             fontSize: 18,
// //                           ),
// //                           overflow: TextOverflow.ellipsis,
// //                         ),
// //                         if (provider.fullName.isNotEmpty ||
// //                             influencerName != null)
// //                           Text(
// //                             'Hi, ${provider.fullName.isNotEmpty ? provider.fullName.split(' ').first : influencerName?.split(' ').first ?? 'Creator'}!',
// //                             style: TextStyle(
// //                               color: Colors.black54,
// //                               fontSize: 12,
// //                             ),
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               );
// //             },
// //           ),
// //           actions: [
// //             // Notification Bell
// //             Stack(
// //               alignment: Alignment.center,
// //               children: [
// //                 IconButton(
// //                   icon: Icon(
// //                     Icons.notifications_outlined,
// //                     color: Colors.black87,
// //                     size: 24,
// //                   ),
// //                   onPressed: widget.onNotificationTap,
// //                 ),
// //                 if (widget.hasUnreadNotifications)
// //                   Positioned(
// //                     top: 12,
// //                     right: 12,
// //                     child: Container(
// //                       height: 10,
// //                       width: 10,
// //                       decoration: BoxDecoration(
// //                         color: Colors.red,
// //                         shape: BoxShape.circle,
// //                         border: Border.all(color: Colors.white, width: 1.5),
// //                       ),
// //                     ),
// //                   ),
// //               ],
// //             ),

// //             // Chat Icon
// //             IconButton(
// //               icon: Icon(
// //                 Icons.chat_bubble_outline_rounded,
// //                 color: Colors.black87,
// //                 size: 22,
// //               ),
// //               onPressed: widget.onChatTap,
// //             ),

// //             // Avatar with Dropdown
// //             Consumer<InfluencerOnboardingProvider>(
// //               builder: (context, provider, child) {
// //                 return PopupMenuButton(
// //                   offset: Offset(0, 50),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   icon: Container(
// //                     height: 36,
// //                     width: 36,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       border: Border.all(color: Colors.white, width: 2),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.black.withOpacity(0.1),
// //                           blurRadius: 8,
// //                           offset: Offset(0, 2),
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipRRect(
// //                       borderRadius: BorderRadius.circular(18),
// //                       child:
// //                           provider.profileImageUrl != null || profileUrl != null
// //                               ? Image.network(
// //                                 provider.profileImageUrl ?? profileUrl!,
// //                                 fit: BoxFit.cover,
// //                                 errorBuilder:
// //                                     (context, error, stackTrace) =>
// //                                         Icon(Icons.person, color: Colors.grey),
// //                               )
// //                               : Icon(Icons.person, color: Colors.grey),
// //                     ),
// //                   ),
// //                   itemBuilder:
// //                       (context) => [
// //                         PopupMenuItem(
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.person, color: Colors.black54),
// //                               SizedBox(width: 12),
// //                               Text('Profile'),
// //                             ],
// //                           ),
// //                           value: 'profile',
// //                         ),
// //                         PopupMenuItem(
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.settings, color: Colors.black54),
// //                               SizedBox(width: 12),
// //                               Text('Settings'),
// //                             ],
// //                           ),
// //                           value: 'settings',
// //                         ),
// //                         PopupMenuItem(
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.help_outline, color: Colors.black54),
// //                               SizedBox(width: 12),
// //                               Text('Help & Support'),
// //                             ],
// //                           ),
// //                           value: 'help',
// //                         ),
// //                         PopupMenuItem(
// //                           child: Row(
// //                             children: [
// //                               Icon(Icons.logout, color: Colors.red),
// //                               SizedBox(width: 12),
// //                               Text(
// //                                 'Logout',
// //                                 style: TextStyle(color: Colors.red),
// //                               ),
// //                             ],
// //                           ),
// //                           value: 'logout',
// //                         ),
// //                       ],
// //                   onSelected: widget.onProfileMenuSelect,
// //                 );
// //               },
// //             ),
// //             SizedBox(width: 8),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:ui';

// import 'package:creatorcrew/infliencers/PrifleCreation/Screens/influencerSeasionManager.dart';
// import 'package:flutter/material.dart';

// class InfluencerGlassmorphicAppBar extends StatefulWidget
//     implements PreferredSizeWidget {
//   final String currentPageTitle;
//   final VoidCallback? onNotificationTap;
//   final VoidCallback? onChatTap;
//   final Function(String)? onProfileMenuSelect;

//   const InfluencerGlassmorphicAppBar({
//     Key? key,
//     required this.currentPageTitle,
//     this.onNotificationTap,
//     this.onChatTap,
//     this.onProfileMenuSelect,
//   }) : super(key: key);

//   @override
//   Size get preferredSize => const Size.fromHeight(80);

//   @override
//   _InfluencerGlassmorphicAppBarState createState() =>
//       _InfluencerGlassmorphicAppBarState();
// }

// class _InfluencerGlassmorphicAppBarState
//     extends State<InfluencerGlassmorphicAppBar> {
//   String? influencerName;
//   String? influencerUsername;
//   String? profileImageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _loadInfluencerData();
//   }

//   Future<void> _loadInfluencerData() async {
//     final data = await InfluencerSessionManager.getInfluencerData();
//     setState(() {
//       influencerName = data['name'];
//       influencerUsername = data['username'];
//       profileImageUrl = data['profileUrl'];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       child: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Colors.white.withOpacity(0.2),
//                   Colors.white.withOpacity(0.1),
//                 ],
//               ),
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.white.withOpacity(0.2),
//                   width: 1,
//                 ),
//               ),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Row(
//                   children: [
//                     // Profile section
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.white.withOpacity(0.2),
//                           backgroundImage:
//                               profileImageUrl != null
//                                   ? NetworkImage(profileImageUrl!)
//                                   : null,
//                           child:
//                               profileImageUrl == null
//                                   ? Icon(
//                                     Icons.person,
//                                     color: Colors.white,
//                                     size: 24,
//                                   )
//                                   : null,
//                         ),
//                         const SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               influencerName ?? 'Influencer',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             if (influencerUsername != null)
//                               Text(
//                                 '@${influencerUsername}',
//                                 style: TextStyle(
//                                   color: Colors.white.withOpacity(0.8),
//                                   fontSize: 12,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     // Page title
//                     Text(
//                       widget.currentPageTitle,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const Spacer(),
//                     // Action buttons
//                     Row(
//                       children: [
//                         _buildActionButton(
//                           icon: Icons.notifications_outlined,
//                           onTap: widget.onNotificationTap,
//                         ),
//                         const SizedBox(width: 8),
//                         _buildActionButton(
//                           icon: Icons.chat_bubble_outline,
//                           onTap: widget.onChatTap,
//                         ),
//                         const SizedBox(width: 8),
//                         _buildProfileMenu(),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({required IconData icon, VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(icon, color: Colors.white, size: 20),
//       ),
//     );
//   }

//   Widget _buildProfileMenu() {
//     return PopupMenuButton<String>(
//       onSelected: widget.onProfileMenuSelect,
//       icon: Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
//       ),
//       itemBuilder:
//           (context) => [
//             const PopupMenuItem(
//               value: 'profile',
//               child: Row(
//                 children: [
//                   Icon(Icons.person_outline),
//                   SizedBox(width: 8),
//                   Text('Profile'),
//                 ],
//               ),
//             ),
//             const PopupMenuItem(
//               value: 'settings',
//               child: Row(
//                 children: [
//                   Icon(Icons.settings_outlined),
//                   SizedBox(width: 8),
//                   Text('Settings'),
//                 ],
//               ),
//             ),
//             const PopupMenuItem(
//               value: 'logout',
//               child: Row(
//                 children: [
//                   Icon(Icons.logout_outlined),
//                   SizedBox(width: 8),
//                   Text('Logout'),
//                 ],
//               ),
//             ),
//           ],
//     );
//   }
// }
import 'dart:ui';

import 'package:creatorcrew/infliencers/PrifleCreation/Screens/influencerSeasionManager.dart';
import 'package:creatorcrew/infliencers/PrifleCreation/providers/InfluencerOnboardingProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InfluencerGlassmorphicAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String currentPageTitle;
  final bool hasUnreadNotifications;
  final Function()? onNotificationTap;
  final Function()? onChatTap;
  final Function(String)? onProfileMenuSelect;

  const InfluencerGlassmorphicAppBar({
    Key? key,
    required this.currentPageTitle,
    this.hasUnreadNotifications = false,
    this.onNotificationTap,
    this.onChatTap,
    this.onProfileMenuSelect,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(70.0);

  @override
  _InfluencerGlassmorphicAppBarState createState() =>
      _InfluencerGlassmorphicAppBarState();
}

class _InfluencerGlassmorphicAppBarState
    extends State<InfluencerGlassmorphicAppBar> {
  String? influencerName;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    _loadInfluencerData();
  }

  Future<void> _loadInfluencerData() async {
    // Use InfluencerSessionManager instead of direct SharedPreferences
    final data = await InfluencerSessionManager.getInfluencerData();
    setState(() {
      influencerName = data['name'];
      profileUrl = data['profileUrl'];
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
          title: Consumer<InfluencerOnboardingProvider>(
            builder: (context, provider, child) {
              return Row(
                children: [
                  // Profile Avatar
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
                          provider.profileImageUrl != null || profileUrl != null
                              ? Image.network(
                                provider.profileImageUrl ?? profileUrl!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        Icon(Icons.person, color: Colors.grey),
                              )
                              : Icon(Icons.person, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 10),

                  // Welcome Text and Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.currentPageTitle,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (provider.fullName.isNotEmpty ||
                            influencerName != null)
                          Text(
                            'Hi, ${provider.fullName.isNotEmpty ? provider.fullName.split(' ').first : influencerName?.split(' ').first ?? 'Creator'}!',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
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

            // Avatar with Dropdown
            Consumer<InfluencerOnboardingProvider>(
              builder: (context, provider, child) {
                return PopupMenuButton(
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
                          provider.profileImageUrl != null || profileUrl != null
                              ? Image.network(
                                provider.profileImageUrl ?? profileUrl!,
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
                              Icon(Icons.help_outline, color: Colors.black54),
                              SizedBox(width: 12),
                              Text('Help & Support'),
                            ],
                          ),
                          value: 'help',
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 12),
                              Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                          value: 'logout',
                        ),
                      ],
                  onSelected: widget.onProfileMenuSelect,
                );
              },
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
