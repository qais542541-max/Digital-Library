import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // متغير محلي لتغيير شكل زر الوضع المظلم (مؤقتاً حتى نربطه بإدارة الحالة)
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero, // لإلغاء الهامش العلوي الافتراضي
        children: [
          // 1. رأس القائمة (Drawer Header) - مساحة خضراء في الأعلى لشعار التطبيق
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32), // اللون الأخضر المعتمد في تطبيقك
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.local_library, size: 35, color: Color(0xFF2E7D32)),
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

          // 2. زر المفضلة
          _buildDrawerItem(
            title: 'المفضلة',
            icon: Icons.bookmark_border,
            onTap: () {
              // مسار الانتقال لشاشة المفضلة
              print('تم الضغط على المفضلة');
            },
          ),

          // 3. زر تحميلاتي
          _buildDrawerItem(
            title: 'تحميلاتي',
            icon: Icons.file_download_outlined,
            onTap: () {
              print('تم الضغط على تحميلاتي');
            },
          ),

          // فاصل خطي خفيف لتنظيم القائمة
          const Divider(height: 30, thickness: 1, indent: 20, endIndent: 20),

          // 4. زر الإعدادات
          _buildDrawerItem(
            title: 'إعدادات',
            icon: Icons.settings_outlined,
            onTap: () {
              print('تم الضغط على الإعدادات');
            },
          ),

          // 5. زر الوضع المظلم (باستخدام Switch)
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined, color: Colors.black87, size: 28),
            title: const Text(
              'الوضع المظلم',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            trailing: Switch(
              value: isDarkMode,
              activeColor: const Color(0xFF2E7D32),
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                // 🌐 مكان ربط تغيير ثيم التطبيق بالكامل
                print('الوضع المظلم الآن: $isDarkMode');
              },
            ),
          ),

          // 6. زر من نحن
          _buildDrawerItem(
            title: 'من نحن',
            icon: Icons.info_outline, // أيقونة مشابهة للصورة
            onTap: () {
              print('تم الضغط على من نحن');
            },
          ),
        ],
      ),
    );
  }

  // دالة مساعدة برمجية لبناء الأزرار بشكل نظيف وموحد (DRY Principle)
  Widget _buildDrawerItem({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}