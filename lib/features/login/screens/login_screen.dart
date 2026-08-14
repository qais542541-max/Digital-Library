import 'package:flutter/material.dart';
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
          mockUserName = 'عمار العقبي'; // تم تحديد اسم الطالب
          break;
        case UserRole.teacher:
          mockUserName = 'د. أحمد الشيباني';
          break;
        case UserRole.employee:
          mockUserName = 'يوسف شمسان';
          break;
        case UserRole.external:
          mockUserName = 'محمد أحمد';
          break;
        case UserRole.guest:
          mockUserName = 'زائر (ضيف)';
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
              const Text(
                'المكتبة الرقمية (نسخة التجربة)',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'اختر صلاحية الدخول لمعاينة الواجهات',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // 1. زر الطالب
              _buildRoleButton(
                title: 'دخول كطالب',
                icon: Icons.school,
                color: const Color(0xFF2E7D32),
                onTap: () => loginAs(UserRole.student),
              ),

              // 2. زر المعلم
              _buildRoleButton(
                title: 'دخول كعضو هيئة تدريس',
                icon: Icons.workspace_premium,
                color: Colors.blue.shade700,
                onTap: () => loginAs(UserRole.teacher),
              ),

              // 3. زر الموظف الإداري
              _buildRoleButton(
                title: 'دخول كموظف إداري (كنترول)',
                icon: Icons.admin_panel_settings,
                color: Colors.orange.shade700,
                onTap: () => loginAs(UserRole.employee),
              ),

              // 4. زر الزائر الخارجي المسجل
              _buildRoleButton(
                title: 'دخول كباحث خارجي مسجل',
                icon: Icons.person,
                color: Colors.teal,
                onTap: () => loginAs(UserRole.external),
              ),

              const Divider(height: 40, thickness: 1),

              // 5. زر الضيف غير المسجل
              TextButton.icon(
                onPressed: () => loginAs(UserRole.guest),
                icon: const Icon(Icons.explore, color: Colors.grey),
                label: const Text(
                  'تصفح التطبيق كضيف (بدون حساب)',
                  style: TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.underline),
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