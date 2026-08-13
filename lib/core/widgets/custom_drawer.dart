import 'package:flutter/material.dart';
import '../../features/layout/screens/main_screen.dart'; // 👈 1. استدعاء ملف الـ enum لمعرفة الصلاحية

class CustomDrawer extends StatelessWidget {
  final UserRole role; // 👈 2. استقبال دور المستخدم

  const CustomDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // تحديد بيانات رأس القائمة (Header) برمجياً حسب الدور
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
      child: Column(
        children: [
          // 1. رأس القائمة (Header)
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF2E7D32)),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(userDesc),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(userIcon, size: 40, color: const Color(0xFF2E7D32)),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 2. الملف الشخصي (يُخفى عن الضيف فقط)
                if (role != UserRole.guest)
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('الملف الشخصي'),
                    onTap: () {
                      // الانتقال لشاشة الملف الشخصي
                    },
                  ),

                // 3. ملفاتي / تنزيلاتي (تُخفى عن الضيف وعن الموظف)
                if (role != UserRole.guest && role != UserRole.employee)
                  ListTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('ملفاتي وتنزيلاتي'),
                    onTap: () {
                      // الانتقال لشاشة الملفات
                    },
                  ),

                // 4. المفضلة (تظهر للجميع، ولكن للضيف نبرمجها لتعرض رسالة طلب تسجيل دخول)
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('المفضلة'),
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
                      // الانتقال لشاشة المفضلة
                    }
                  },
                ),

                const Divider(),

                // 5. الإعدادات العامة (تظهر للجميع)
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('الإعدادات'),
                  onTap: () {
                    // الانتقال لشاشة الإعدادات
                  },
                ),
              ],
            ),
          ),

          // 6. زر تسجيل الدخول / الخروج الذكي
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              role == UserRole.guest ? Icons.login : Icons.logout,
              color: role == UserRole.guest ? const Color(0xFF2E7D32) : Colors.red,
            ),
            title: Text(
              role == UserRole.guest ? 'تسجيل الدخول / إنشاء حساب' : 'تسجيل الخروج',
              style: TextStyle(
                color: role == UserRole.guest ? const Color(0xFF2E7D32) : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // توجيه المستخدم لشاشة تسجيل الدخول الرئيسية
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}