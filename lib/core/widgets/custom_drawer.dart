import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/downloads/screens/downloads_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/about_us/about_screen.dart';
import '../../features/settings/screens/profile_screen.dart';
import '../../features/layout/screens/main_screen.dart';
// في ملف main_screen.dart
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';

// داخل دالة الـ build في MainScreen:


const Color appPrimaryGreen = Color(0xFF2E7D32);

class CustomDrawer extends StatelessWidget {
  final UserRole role;

  const CustomDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<SettingsProvider>(context);
    final isArabic = context.locale.languageCode == 'ar';

    String userName = 'custom_drawer.guest_user'.tr();
    String userDesc = 'custom_drawer.browse_without_account'.tr();
    IconData userIcon = Icons.person_outline;

    if (role == UserRole.student) {
      userName = 'custom_drawer.student_name'.tr();
      userDesc = 'custom_drawer.student_level'.tr();
      userIcon = Icons.school;
    } else if (role == UserRole.teacher) {
      userName = 'custom_drawer.teacher_name'.tr();
      userDesc = 'custom_drawer.faculty_member'.tr();
      userIcon = Icons.workspace_premium;
    } else if (role == UserRole.employee) {
      userName = 'custom_drawer.employee_name'.tr();
      userDesc = 'custom_drawer.library_management'.tr();
      userIcon = Icons.admin_panel_settings;
    } else if (role == UserRole.external) {
      userName = 'custom_drawer.external_researcher_name'.tr();
      userDesc = 'custom_drawer.external_researcher'.tr();
      userIcon = Icons.person;
    }

    return Drawer(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: appPrimaryGreen),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white, fontFamily: 'Cairo')),
            accountEmail: Text(userDesc, style: const TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(userIcon, size: 40, color: appPrimaryGreen),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // 1. تجميع العناصر المخفية عن الضيف في كتلة واحدة نظيفة
                if (role != UserRole.guest) ...[
                  _buildDrawerItem(
                    title: 'custom_drawer.profile'.tr(),
                    icon: Icons.person_outline,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(role: role)));
                    },
                  ),
                  const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                  _buildDrawerItem(
                    title: 'custom_drawer.my_downloads'.tr(),
                    icon: Icons.file_download_outlined,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadsScreen(role: role)));
                    },
                  ),
                  const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),
                ],

                // 2. العناصر التي تظهر للجميع
                _buildDrawerItem(
                  title: 'custom_drawer.favorites'.tr(),
                  icon: Icons.favorite_border,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    if (role == UserRole.guest) {
                      ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                          content: Text('custom_drawer.login_required_favorites'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
                          backgroundColor: Colors.orange,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      // تم إصلاح النقص هنا بتمرير role
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen(role: role)));
                    }
                  },
                ),
                const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                _buildDrawerItem(
                  title: 'custom_drawer.about_us'.tr(),
                  icon: Icons.info_outline,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                  },
                ),
                const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                _buildDrawerItem(
                  title: 'custom_drawer.settings'.tr(),
                  icon: Icons.settings_outlined,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen(role: role)));
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: Icon(
              role == UserRole.guest ? Icons.login : Icons.logout,
              color: role == UserRole.guest ? appPrimaryGreen : Colors.red,
              size: 26,
            ),
            title: Text(
              role == UserRole.guest ? 'custom_drawer.login_signup'.tr() : 'custom_drawer.logout'.tr(),
              style: TextStyle(
                color: role == UserRole.guest ? appPrimaryGreen : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                fontFamily: 'Cairo',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // TODO: مسار العودة لشاشة تسجيل الدخول
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // دالة بناء الأزرار بتصميم عصري (تم تحسين الهوامش وإضافة سهم)
  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black87, size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
        onTap: onTap,
      ),
    );
  }
}
