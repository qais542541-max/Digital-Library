import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../home//screens/general_main_screen.dart';
import '../../courses/screens/my_courses_screen.dart';
import '../../library/screens/general_library_screen.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../ai_assistant/ai_assistant_screen.dart';
// في ملف main_screen.dart
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';

// داخل دالة الـ build في MainScreen:



enum UserRole { student, teacher, employee, guest, external }

class MainScreen extends StatefulWidget {
  final UserRole role;
  final String userName;

  const MainScreen({
    super.key,
    required this.role,
    required this.userName,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();

}


class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override

  void initState() {
    super.initState();
    _screens = [
      GeneralMainScreen(
        userName: widget.userName,
        userRole: _getRoleName(widget.role),
      ),
      MyCoursesScreen(role: widget.role),
      GeneralLibraryScreen(role: widget.role),
      AiAssistantScreen(role: widget.role), // 👈 إضافة الشاشة هنا
    ];
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.student: return 'main_screen.student'.tr();
      case UserRole.teacher: return 'main_screen.teacher'.tr();
      case UserRole.employee: return 'main_screen.employee'.tr();
      case UserRole.external: return 'main_screen.external_researcher'.tr();
      case UserRole.guest: return 'main_screen.guest'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isArabic = context.locale.languageCode == 'ar';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      drawer: CustomDrawer(role: widget.role),

      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // إبقاء الأيقونات ثابتة عند زيادة عددها
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'main_screen.home'.tr(), // 👈 نص ديناميكي
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.school_outlined),
              activeIcon: const Icon(Icons.school),
              label: 'main_screen.my_courses'.tr(), // 👈 نص ديناميكي
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_library_outlined),
              activeIcon: const Icon(Icons.local_library),
              label: 'main_screen.library'.tr(), // 👈 نص ديناميكي
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.smart_toy_outlined),
              activeIcon: const Icon(Icons.smart_toy),
              label: 'main_screen.assistant'.tr(), // 👈 نص ديناميكي
            ),
          ],
        )
      ),
    );
  }
}
