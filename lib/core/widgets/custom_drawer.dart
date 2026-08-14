import 'package:flutter/material.dart';
import '../../features/downloads/screens/downloads_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/about_us/about_screen.dart';
import '../../features/settings/screens/profile_screen.dart'; // تأكد من مطابقة المسار لهيكلة ملفاتك
import '../../features/layout/screens/main_screen.dart'; // استدعاء ملف الـ enum لمعرفة الصلاحية

const Color appPrimaryGreen = Color(0xFF2E7D32);

class CustomDrawer extends StatelessWidget {
  final UserRole role; // استقبال دور المستخدم

  const CustomDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // 1. قراءة حالة الوضع المظلم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 2. تحديد بيانات رأس القائمة (Header) برمجياً حسب الدور
    String userName = 'زائر (ضيف)';
    String userDesc = 'تصفح المكتبة بدون حساب';
    IconData userIcon = Icons.person_outline;

    if (role == UserRole.student) {
      userName = 'عمار العقبي'; // سيأتي من قاعدة البيانات لاحقاً
      userDesc = 'طالب - مستوى ثالث';
      userIcon = Icons.school;
    } else if (role == UserRole.teacher) {
      userName = 'د. أحمد الشيباني';
      userDesc = 'عضو هيئة تدريس';
      userIcon = Icons.workspace_premium;
    } else if (role == UserRole.employee) {
      userName = 'يوسف شمسان';
      userDesc = 'إدارة المكتبة';
      userIcon = Icons.admin_panel_settings;
    } else if (role == UserRole.external) {
      userName = 'محمد أحمد';
      userDesc = 'باحث خارجي';
      userIcon = Icons.person;
    }

    return Drawer(
      // تكيف لون خلفية القائمة مع الوضع المظلم
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: Column(
        children: [
          // 3. رأس القائمة (Header) المدمج
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: appPrimaryGreen),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            accountEmail: Text(userDesc, style: const TextStyle(color: Colors.white70)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(userIcon, size: 40, color: appPrimaryGreen),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 4. الملف الشخصي (يُخفى عن الضيف فقط)
                // 4. الملف الشخصي (يُخفى عن الضيف فقط)
                // 4. الملف الشخصي (يُخفى عن الضيف فقط)
                if (role != UserRole.guest)
                // 8. الإعدادات (تظهر للجميع)
                // 4. الملف الشخصي (يُخفى عن الضيف فقط)
                  if (role != UserRole.guest)
                    _buildDrawerItem(
                      context: context,
                      title: 'الملف الشخصي', // 👈 التأكد من أن العنوان هو الملف الشخصي
                      icon: Icons.person_outline, // 👈 أيقونة الشخص
                      isDarkMode: isDarkMode,
                      onTap: () {
                        Navigator.pop(context); // إغلاق القائمة الجانبية أولاً
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen(role: role)), // تمرير دور المستخدم الفعلي
                        );
                      },
                    ),

                if (role != UserRole.guest)
                  const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                // 5. التنزيلات (تُخفى عن الضيف وعن الموظف)
                if (role != UserRole.guest && role != UserRole.employee)
                  _buildDrawerItem(
                    context: context,
                    title: 'ملفاتي وتنزيلاتي',
                    icon: Icons.file_download_outlined,
                    isDarkMode: isDarkMode,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadsScreen()));
                    },
                  ),

                if (role != UserRole.guest && role != UserRole.employee)
                  const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                // 6. المفضلة (تظهر للجميع مع حماية مخصصة للضيف)
                _buildDrawerItem(
                  context: context,
                  title: 'مفضلاتي',
                  icon: Icons.favorite_border,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    if (role == UserRole.guest) {
                      Navigator.pop(context); // إغلاق القائمة
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى تسجيل الدخول أو إنشاء حساب لحفظ مفضلاتك!'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
                    }
                  },
                ),

                const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                // 7. من نحن (تظهر للجميع)
                _buildDrawerItem(
                  context: context,
                  title: 'من نحن',
                  icon: Icons.info_outline,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutScreen()));
                  },
                ),

                const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

                // 8. الإعدادات (تظهر للجميع)
                _buildDrawerItem(
                  context: context,
                  title: 'الإعدادات',
                  icon: Icons.settings_outlined,
                  isDarkMode: isDarkMode,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen(role: role)),
                    );
                  },
                ),
              ],
            ),
          ),

          // 9. زر تسجيل الدخول / الخروج الذكي
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              role == UserRole.guest ? Icons.login : Icons.logout,
              color: role == UserRole.guest ? appPrimaryGreen : Colors.red,
              size: 28,
            ),
            title: Text(
              role == UserRole.guest ? 'تسجيل الدخول / إنشاء حساب' : 'تسجيل الخروج',
              style: TextStyle(
                color: role == UserRole.guest ? appPrimaryGreen : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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

  // دالة بناء الأزرار الموحدة والذكية
  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black87, size: 28),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}