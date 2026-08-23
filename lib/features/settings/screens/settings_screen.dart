import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../layout/screens/main_screen.dart';
import 'change_password_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  final UserRole role;

  const SettingsScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        leading: const SizedBox(),
        title: Text(
            'settings_screen.title'.tr(),
            style: TextStyle(color: isDarkMode ? Colors.white : primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo')
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainScreen(role: role, userName: 'عمار')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          // 1. قسم الحساب
          if (role != UserRole.guest) ...[
            _buildSectionHeader('settings_screen.account'.tr(), primaryGreen),
            _buildListTile(
              Icons.person_outline,
              'settings_screen.profile'.tr(),
              'settings_screen.edit_student_data'.tr(),
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(role: role))),
              iconColor: isDarkMode ? Colors.white : Colors.black87,
              textColor: isDarkMode ? Colors.white : Colors.black87,
            ),
            _buildListTile(
              Icons.lock_outline,
              'settings_screen.change_password'.tr(),
              'settings_screen.update_password_desc'.tr(),
                  () => showChangePasswordDialog(context, isDarkMode),
              iconColor: isDarkMode ? Colors.white : Colors.black87,
              textColor: isDarkMode ? Colors.white : Colors.black87,
            ),
            const Divider(height: 30, indent: 20, endIndent: 20),
          ],

          // 2. التفضيلات والإشعارات
          _buildSectionHeader('settings_screen.preferences_and_notifications'.tr(), primaryGreen),
          _buildListTile(
            Icons.language,
            'settings_screen.app_language'.tr(),
            context.locale.languageCode == 'ar' ? 'settings_screen.arabic'.tr() : 'settings_screen.english'.tr(),
                () => _showLanguageDialog(context, primaryGreen, isDarkMode),
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),

          SwitchListTile(
            title: Text('settings_screen.dark_mode'.tr(), style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            secondary: Icon(Icons.dark_mode_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: isDarkMode,
            onChanged: (bool value) => settings.toggleDarkMode(value),
          ),

          SwitchListTile(
            title: Text('settings_screen.new_resource_notifications'.tr(), style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            subtitle: Text('settings_screen.new_resource_notifications_desc'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
            secondary: Icon(Icons.notifications_active_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.generalNotifications,
            onChanged: (bool value) => settings.toggleGeneralNotifications(value),
          ),

          SwitchListTile(
            title: Text('settings_screen.physical_library_alerts'.tr(), style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            subtitle: Text('settings_screen.physical_library_alerts_desc'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
            secondary: Icon(Icons.menu_book_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.physicalBookAlerts,
            onChanged: (bool value) => settings.togglePhysicalBookAlerts(value),
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          // 3. التخزين والبيانات
          _buildSectionHeader('settings_screen.storage_and_data'.tr(), primaryGreen),
          _buildListTile(
            Icons.delete_outline, 'settings_screen.clear_cache'.tr(), 'settings_screen.clear_cache_desc'.tr(), () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('settings_screen.clear_cache_success'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          // 4. أخرى
          _buildSectionHeader('settings_screen.other'.tr(), primaryGreen),
          _buildListTile(
            Icons.info_outline, 'settings_screen.about_app'.tr(), 'settings_screen.version'.tr(args: ['1.0.0']), () {},
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color, fontFamily: 'Cairo')),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback onTap, {Color? iconColor, Color? textColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: Icon(icon, color: iconColor, size: 26),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontFamily: 'Cairo')),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'Cairo')) : null,
      onTap: onTap,
    );
  }

  void _showLanguageDialog(BuildContext context, Color primaryGreen, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final currentLang = context.locale.languageCode;

            return AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text(
                'settings_screen.choose_language'.tr(),
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Cairo'),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    value: 'ar',
                    groupValue: currentLang,
                    activeColor: primaryGreen,
                    onChanged: (String? value) async {
                      if (value != null) {
                        await context.setLocale(const Locale('ar'));
                        setState(() {});
                      }
                      Navigator.pop(dialogContext);
                    },
                    title: Text('settings_screen.arabic'.tr(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
                  ),
                  RadioListTile<String>(
                    value: 'en',
                    groupValue: currentLang,
                    activeColor: primaryGreen,
                    onChanged: (String? value) async {
                      if (value != null) {
                        await context.setLocale(const Locale('en'));
                        setState(() {});
                      }
                      Navigator.pop(dialogContext);
                    },
                    title: Text('settings_screen.english'.tr(), style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}