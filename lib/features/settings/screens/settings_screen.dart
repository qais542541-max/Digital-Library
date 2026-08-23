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
        leading: const SizedBox(), // تفريغ اليمين
        title: Text(
            'الإعدادات',
            style: TextStyle(color: isDarkMode ? Colors.white : primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo')
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          // 1. قسم الحساب (مخفي عن الضيف)
          if (role != UserRole.guest) ...[
            _buildSectionHeader('الحساب', primaryGreen),
            _buildListTile(
              Icons.person_outline,
              'الملف الشخصي',
              'تعديل بيانات الطالب',
                  () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(role: role))),
              iconColor: isDarkMode ? Colors.white : Colors.black87,
              textColor: isDarkMode ? Colors.white : Colors.black87,
            ),
            _buildListTile(
              Icons.lock_outline,
              'تغيير كلمة المرور',
              'تحديث الرمز السري لحسابك',
                  () => showChangePasswordDialog(context, isDarkMode),
              iconColor: isDarkMode ? Colors.white : Colors.black87,
              textColor: isDarkMode ? Colors.white : Colors.black87,
            ),
            const Divider(height: 30, indent: 20, endIndent: 20),
          ],

          // 2. التفضيلات والإشعارات
          _buildSectionHeader('التفضيلات والإشعارات', primaryGreen),
          _buildListTile(
            Icons.language,
            'لغة التطبيق',
            context.locale.languageCode == 'ar' ? 'العربية' : 'English', // 👈 التعديل هنا
                () => _showLanguageDialog(context, primaryGreen, isDarkMode), // 👈 حذفنا settings من هنا
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),

          SwitchListTile(
            title: const Text('الوضع المظلم', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            secondary: Icon(Icons.dark_mode_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: isDarkMode,
            onChanged: (bool value) => settings.toggleDarkMode(value),
          ),

          SwitchListTile(
            title: const Text('إشعارات الموارد الجديدة', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            subtitle: const Text('تنبيه عند رفع ملازم أو تكاليف جديدة', style: TextStyle(fontFamily: 'Cairo')),
            secondary: Icon(Icons.notifications_active_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.generalNotifications,
            onChanged: (bool value) => settings.toggleGeneralNotifications(value),
          ),

          SwitchListTile(
            title: const Text('تنبيهات المكتبة الفعلية', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Cairo')),
            subtitle: const Text('تذكير بمواعيد إرجاع الكتب الورقية', style: TextStyle(fontFamily: 'Cairo')),
            secondary: Icon(Icons.menu_book_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.physicalBookAlerts,
            onChanged: (bool value) => settings.togglePhysicalBookAlerts(value),
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          // 3. التخزين والبيانات (يحتوي فقط على مسح الذاكرة لتنظيف الواجهة)
          _buildSectionHeader('التخزين والبيانات', primaryGreen),
          _buildListTile(
            Icons.delete_outline, 'مسح الذاكرة المؤقتة (Cache)', 'توفير مساحة التخزين في الهاتف', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم مسح الذاكرة المؤقتة بنجاح', style: TextStyle(fontFamily: 'Cairo')),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          // 4. أخرى
          _buildSectionHeader('أخرى', primaryGreen),
          _buildListTile(
            Icons.info_outline, 'حول التطبيق', 'الإصدار 1.0.0', () {},
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
        // 👇 استخدمنا StatefulBuilder لكي نتمكن من تحديث نافذة الحوار من الداخل
        return StatefulBuilder(
          builder: (context, setState) {
            // نقرأ اللغة الحالية داخل الـ builder لكي تتحدث مع كل تغيير
            final currentLang = context.locale.languageCode;

            return AlertDialog(
              backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Text(
                'settings_screen.choose_language'.tr(), // 👈 استخدام الترجمة للعنوان
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
                        // 1. نغير اللغة في التطبيق
                        await context.setLocale(const Locale('ar'));
                        // 2. نحدث نافذة الحوار ليتغير اختيار الراديو
                        setState(() {});
                      }
                      Navigator.pop(dialogContext); // إغلاق النافذة
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