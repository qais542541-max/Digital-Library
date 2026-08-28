import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
// 👇 استدعاء شاشة الحاوية الرئيسية وملف الـ enum
import '../../layout/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 👇 التعديل هنا: دالة التوجيه السريع لتشمل اسم المستخدم بناءً على الصلاحية
    void loginAs(UserRole role) {
      String mockUserName = '';

      // تحديد اسم افتراضي للتجربة حسب الدور الذي تم اختياره
      switch (role) {
        case UserRole.student:
          mockUserName = 'login_screen.student_name'.tr(); // تم تحديد اسم الطالب
          break;
        case UserRole.teacher:
          mockUserName = 'login_screen.teacher_name'.tr();
          break;
        case UserRole.employee:
          mockUserName = 'login_screen.employee_name'.tr();
          break;
        case UserRole.external:
          mockUserName = 'login_screen.external_name'.tr();
          break;
        case UserRole.guest:
          mockUserName = 'login_screen.guest_name'.tr();
          break;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // 👈 تمرير الصلاحية والاسم معاً لحل الخطأ
          builder: (context) => MainScreen(role: role, userName: mockUserName),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.local_library,
                size: 100,
                color: Color(0xFF2E7D32),
              ),
              const SizedBox(height: 20),
              Text(
                'login_screen.app_title'.tr(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'login_screen.choose_role'.tr(),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // 1. زر الطالب
              _buildRoleButton(
                title: 'login_screen.login_as_student'.tr(),
                icon: Icons.school,
                color: const Color(0xFF2E7D32),
                onTap: () => loginAs(UserRole.student),
              ),

              // 2. زر المعلم
              _buildRoleButton(
                title: 'login_screen.login_as_teacher'.tr(),
                icon: Icons.workspace_premium,
                color: Colors.blue.shade700,
                onTap: () => loginAs(UserRole.teacher),
              ),

              // 3. زر الموظف الإداري
              _buildRoleButton(
                title: 'login_screen.login_as_employee'.tr(),
                icon: Icons.admin_panel_settings,
                color: Colors.orange.shade700,
                onTap: () => loginAs(UserRole.employee),
              ),

              // 4. زر الزائر الخارجي المسجل
              _buildRoleButton(
                title: 'login_screen.login_as_external'.tr(),
                icon: Icons.person,
                color: Colors.teal,
                onTap: () => loginAs(UserRole.external),
              ),

              const Divider(height: 40, thickness: 1),

              // 5. زر الضيف غير المسجل
              TextButton.icon(
                onPressed: () => loginAs(UserRole.guest),
                icon: const Icon(Icons.explore, color: Colors.grey),
                label: Text(
                  'login_screen.browse_as_guest'.tr(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لرسم الأزرار بشكل أنيق وموحد
  Widget _buildRoleButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          icon: Icon(icon, color: Colors.white),
          label: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
