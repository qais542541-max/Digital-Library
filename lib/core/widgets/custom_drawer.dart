import 'package:flutter/material.dart';
import '../../features/downloads/screens/downloads_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/about_us/about_screen.dart';

const Color appPrimaryGreen = Color(0xFF2E7D32);

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. قراءة حالة الوضع المظلم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      // 2. السحر هنا: خلفية رمادية داكنة في الوضع المظلم، وبيضاء في الفاتح
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // رأس القائمة
          DrawerHeader(
            decoration: const BoxDecoration(
              color: appPrimaryGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.local_library, size: 35, color: appPrimaryGreen),
                ),
                SizedBox(height: 12),
                Text(
                  'المكتبة الشاملة',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // تمرير حالة الثيم (isDarkMode) لكل زر ليتكيف لونه
          _buildDrawerItem(
            context: context,
            title: 'مفضلاتي',
            icon: Icons.favorite_border,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen()));
            },
          ),

          const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

          _buildDrawerItem(
            context: context,
            title: 'تحميلاتي',
            icon: Icons.file_download_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DownloadsScreen()));
            },
          ),

          const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

          _buildDrawerItem(
            context: context,
            title: 'إعدادات',
            icon: Icons.settings_outlined,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },
          ),

          const Divider(height: 15, thickness: 1, indent: 20, endIndent: 20),

          _buildDrawerItem(
            context: context,
            title: 'من نحن',
            icon: Icons.info_outline,
            isDarkMode: isDarkMode,
            onTap: () {
              Navigator.pop(context); // إغلاق القائمة الجانبية
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()), // الانتقال لصفحة من نحن
              );
            },
          ),
        ],
      ),
    );
  }

  // 3. دالة بناء الأزرار أصبحت ذكية الآن
  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onTap
  }) {
    return ListTile(
      // الأيقونة بيضاء باهتة في المظلم، وسوداء في الفاتح
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black87, size: 28),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          // النص أبيض في المظلم، وأسود في الفاتح ليكون واضحاً دائماً
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}