import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../home/screens/general_main_screen.dart';
import '../../courses/screens/my_courses_screen.dart';
import '../../library/screens/general_library_screen.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../ai_assistant/ai_assistant_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';

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
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    const Color primaryGreen = Color(0xFF2E7D32);

    // 👇 1. بناء القوائم ديناميكياً بناءً على الصلاحية
    final List<Widget> screens = [];
    final List<NavigationDestination> navDestinations = [];

    // التبويب 1: الرئيسية (للجميع)
    screens.add(GeneralMainScreen(userName: widget.userName, userRole: _getRoleName(widget.role)));
    navDestinations.add(NavigationDestination(
      icon: const Icon(Icons.home_outlined),
      selectedIcon: const Icon(Icons.home_filled),
      label: 'main_screen.home'.tr(),
    ));

    // 👇 التبويب 2: مقرراتي (فقط للطالب والمدرس)
    if (widget.role == UserRole.student || widget.role == UserRole.teacher) {
      screens.add(MyCoursesScreen(role: widget.role));
      navDestinations.add(NavigationDestination(
        icon: const Icon(Icons.school_outlined),
        selectedIcon: const Icon(Icons.school),
        label: 'main_screen.my_courses'.tr(),
      ));
    }

    // التبويب 3: المكتبة (للجميع)
    screens.add(GeneralLibraryScreen(role: widget.role));
    navDestinations.add(NavigationDestination(
      icon: const Icon(Icons.local_library_outlined),
      selectedIcon: const Icon(Icons.local_library),
      label: 'main_screen.library'.tr(),
    ));

    // التبويب 4: الذكاء الاصطناعي (للجميع)
    final int assistantBadgeCount = 1;
    screens.add(AiAssistantScreen(role: widget.role));
    navDestinations.add(NavigationDestination(
      icon: Badge(
        label: Text(assistantBadgeCount.toString(), style: const TextStyle(fontFamily: 'Cairo', fontSize: 10)),
        isLabelVisible: assistantBadgeCount > 0,
        child: const Icon(Icons.smart_toy_outlined),
      ),
      selectedIcon: Badge(
        label: Text(assistantBadgeCount.toString(), style: const TextStyle(fontFamily: 'Cairo', fontSize: 10)),
        isLabelVisible: assistantBadgeCount > 0,
        child: const Icon(Icons.smart_toy),
      ),
      label: 'main_screen.assistant'.tr(),
    ));

    // تأمين مؤشر التنقل لتجنب أخطاء الفهرس
    if (_selectedIndex >= screens.length) _selectedIndex = 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        drawer: CustomDrawer(role: widget.role),
        body: IndexedStack(index: _selectedIndex, children: screens),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scaffoldBgColor.withOpacity(0.0),
                scaffoldBgColor.withOpacity(0.7),
                scaffoldBgColor.withOpacity(1.0),
              ],
              stops: const [0.0, 0.45, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: NavigationBarTheme(
                      data: NavigationBarThemeData(
                        indicatorColor: primaryGreen.withOpacity(0.2),
                        height: 70,
                      ),
                      child: NavigationBar(
                        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E).withOpacity(0.85) : Colors.white.withOpacity(0.90),
                        elevation: 0,
                        selectedIndex: _selectedIndex,
                        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                        destinations: navDestinations, // 👈 استخدام القائمة الديناميكية
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}