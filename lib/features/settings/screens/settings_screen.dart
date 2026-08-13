import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../downloads/screens/downloads_screen.dart';
import 'change_password_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);

    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;


    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          _buildSectionHeader('الحساب', primaryGreen),
          _buildListTile(
            Icons.person_outline,
            'الملف الشخصي',
            'تعديل بيانات الطالب',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()), // ضَع اسم شاشتك هنا
              );
            },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          _buildListTile(
            Icons.lock_outline,
            'تغيير كلمة المرور',
            '',
                () {
              showChangePasswordDialog(context, isDarkMode); // استدعاء نظيف ومباشر!
            },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          _buildSectionHeader('التفضيلات والإشعارات', primaryGreen),

          _buildListTile(
            Icons.language,
            'لغة التطبيق',
            // 👇 هنا جعلناه يتغير تلقائياً بناءً على ما اختاره الطالب
            settings.languageCode == 'ar' ? 'العربية' : 'English',
                () {
              _showLanguageDialog(context, primaryGreen, isDarkMode, settings);
            },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),

          SwitchListTile(
            title: const Text('الوضع المظلم', style: TextStyle(fontWeight: FontWeight.w600)),
            secondary: Icon(Icons.dark_mode_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: isDarkMode,
            onChanged: (bool value) {
              settings.toggleDarkMode(value);
            },
          ),

          SwitchListTile(
            title: const Text('إشعارات الموارد الجديدة', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('تنبيه عند رفع ملازم أو تكاليف جديدة للمواد'),
            secondary: Icon(Icons.notifications_active_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.generalNotifications,
            onChanged: (bool value) {
              settings.toggleGeneralNotifications(value);
            },
          ),

          SwitchListTile(
            title: const Text('تنبيهات المكتبة الفعلية', style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('تذكير بمواعيد إرجاع الكتب الورقية المُعارة'),
            secondary: Icon(Icons.menu_book_outlined, color: isDarkMode ? Colors.white : Colors.black87),
            activeThumbColor: Colors.white,
            activeTrackColor: primaryGreen,
            value: settings.physicalBookAlerts,
            onChanged: (bool value) {
              settings.togglePhysicalBookAlerts(value);
            },
          ),

          const Divider(height: 30, indent: 20, endIndent: 20),

          _buildSectionHeader('التخزين والبيانات', primaryGreen),

          _buildListTile(
            Icons.folder_outlined, 'إدارة التحميلات', 'عرض وحذف الملفات المحملة', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DownloadsScreen()),
            );
          },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),

          _buildListTile(
            Icons.delete_outline, 'مسح الذاكرة المؤقتة (Cache)', 'توفير مساحة التخزين في الهاتف', () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم مسح الذاكرة المؤقتة بنجاح'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          const Divider(height: 30, indent: 20, endIndent: 20),

          _buildSectionHeader('أخرى', primaryGreen),
          _buildListTile(
            Icons.info_outline, 'حول التطبيق', 'الإصدار 1.0.0', () {},
            iconColor: isDarkMode ? Colors.white : Colors.black87,
            textColor: isDarkMode ? Colors.white : Colors.black87,
          ),
          _buildListTile(
            Icons.logout, 'تسجيل الخروج', '', () {},
            iconColor: Colors.red,
            textColor: Colors.red,
          ),
        ],
      ),

    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle, VoidCallback onTap, {Color? iconColor, Color? textColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      leading: Icon(icon, color: iconColor, size: 26),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      onTap: onTap,
    );
  }

  // 👈 2. هنا قمنا باستقبال settings كـ Parameter لتتمكن الدالة من استخدامه
  void _showLanguageDialog(BuildContext context, Color primaryGreen, bool isDarkMode, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            'اختر لغة التطبيق',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: RadioGroup<String>(
            groupValue: settings.languageCode, // الآن سيتعرف على settings بدون أي مشاكل
            onChanged: (String? value) {
              if (value != null) {
                settings.changeLanguage(value);
              }
              Navigator.pop(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'ar',
                  title: Text('العربية', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text('English', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}