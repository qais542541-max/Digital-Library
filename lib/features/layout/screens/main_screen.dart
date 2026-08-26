import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../home/screens/general_main_screen.dart';
import '../../courses/screens/my_courses_screen.dart';
import '../../library/screens/general_library_screen.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../ai_assistant/ai_assistant_screen.dart';
import '../../../core/providers/settings_provider.dart';
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
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // 👇 سنسحب لون خلفية الشاشة لنستخدمه في التغميم المتدرج ليكون التلاشي طبيعياً
    final scaffoldBgColor = Theme.of(context).scaffoldBackgroundColor;
    const Color primaryGreen = Color(0xFF2E7D32);

    final List<Widget> screens = [
      GeneralMainScreen(
        userName: widget.userName,
        userRole: _getRoleName(widget.role),
      ),
      MyCoursesScreen(role: widget.role),
      GeneralLibraryScreen(role: widget.role),
      AiAssistantScreen(role: widget.role),
    ];

    final int assistantBadgeCount = 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        extendBody: true, // مهم جداً ليسمح للمحتوى بالنزول خلف التدرج اللوني
        drawer: CustomDrawer(role: widget.role),
        body: IndexedStack(
          index: _selectedIndex,
          children: screens,
        ),

        // 👇 1. الحاوية الجديدة التي تتحكم بالتدرج اللوني لكامل المنطقة السفلية
        // 👇 الحاوية التي تتحكم بالتدرج اللوني لكامل المنطقة السفلية
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                scaffoldBgColor.withOpacity(0.0), // شفاف تماماً عند الحافة العلوية للشريط
                scaffoldBgColor.withOpacity(0.85), // يغمق بقوة خلف الشريط نفسه
                scaffoldBgColor.withOpacity(1.0), // معتم 100% خلف أزرار النظام
              ],
              stops: const [0.0, 0.4, 1.0],
            ),
          ),
          child: SafeArea(
            bottom: true,
            child: Padding(
              // 👇 السر هنا: جعلنا top: 0 بدلاً من 32 لكي لا يتسرب التدرج اللوني فوق الشريط!
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      color: isDarkMode
                          ? const Color(0xFF1E1E1E).withOpacity(0.85)
                          : Colors.white.withOpacity(0.90),

                      child: NavigationBarTheme(
                        data: NavigationBarThemeData(
                          indicatorColor: primaryGreen.withOpacity(0.2),
                          height: 70,

                          iconTheme: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return const IconThemeData(color: primaryGreen, size: 28);
                            }
                            return IconThemeData(
                                color: isDarkMode ? const Color(0xFF8A939B) : const Color(0xFF707579),
                                size: 24);
                          }),

                          labelTextStyle: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo');
                            }
                            return TextStyle(
                                color: isDarkMode ? const Color(0xFF8A939B) : const Color(0xFF707579),
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                fontFamily: 'Cairo');
                          }),
                        ),
                        child: NavigationBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          selectedIndex: _selectedIndex,
                          onDestinationSelected: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          destinations: [
                            NavigationDestination(
                              icon: const Icon(Icons.home_outlined),
                              selectedIcon: const Icon(Icons.home_filled),
                              label: 'main_screen.home'.tr(),
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.school_outlined),
                              selectedIcon: const Icon(Icons.school),
                              label: 'main_screen.my_courses'.tr(),
                            ),
                            NavigationDestination(
                              icon: const Icon(Icons.local_library_outlined),
                              selectedIcon: const Icon(Icons.local_library),
                              label: 'main_screen.library'.tr(),
                            ),
                            NavigationDestination(
                              icon: Badge(
                                label: Text(
                                  assistantBadgeCount > 99 ? '99+' : assistantBadgeCount.toString(),
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red,
                                isLabelVisible: assistantBadgeCount > 0,
                                offset: const Offset(8, -8),
                                child: const Icon(Icons.smart_toy_outlined),
                              ),
                              selectedIcon: Badge(
                                label: Text(
                                  assistantBadgeCount > 99 ? '99+' : assistantBadgeCount.toString(),
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Colors.red,
                                isLabelVisible: assistantBadgeCount > 0,
                                offset: const Offset(8, -8),
                                child: const Icon(Icons.smart_toy),
                              ),
                              label: 'main_screen.assistant'.tr(),
                            ),
                          ],
                        ),
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