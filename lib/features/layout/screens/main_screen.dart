import 'package:flutter/material.dart';
import '../../courses/screens/my_courses_screen.dart';
import '../../library/screens/general_library_screen.dart';
import '../../ai_assistant/ai_assistant_screen.dart';
import '../../home/screens/general_main_screen.dart';
import '../../../core/widgets/custom_drawer.dart';

// 1. تعريف الأدوار بوضوح تام (يمكنك وضع هذا الـ enum في ملف منفصل لاحقاً لترتيب أفضل)
// تعريف الأدوار ليطابق قاعدة البيانات تماماً
enum UserRole {
  student,   // يطابق library_members -> student
  teacher,   // يطابق library_members -> teacher
  employee,  // يطابق users -> employees
  external,  // يطابق library_members -> external (ضيف مسجل)
  guest      // مستخدم بدون حساب إطلاقاً
}

class MainScreen extends StatefulWidget {
  final UserRole role; // نستقبل دور المستخدم هنا

  const MainScreen({super.key, required this.role});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 2. دالة ذكية تحدد الشاشات المسموحة بناءً على الدور
  List<Widget> _getScreens() {
    List<Widget> screens = [];

    // الجميع يرى الشاشة الرئيسية المشتركة (مع تغيير الاسم والصفة لاحقاً برمجياً)
    screens.add(const GeneralMainScreen(
      userName: 'مرحباً بك', // سيتم جلبها من قاعدة البيانات لاحقاً
      userRole: 'النظام الأكاديمي',
    ));

    // شاشة "مقرراتي" تظهر للطالب والمعلم فقط (لا تظهر للموظف الإداري أو الضيف)
    if (widget.role == UserRole.student || widget.role == UserRole.teacher) {
      screens.add(MyCoursesScreen(role: widget.role)); // نمرر الدور للشاشة
    }

    // الجميع يرى المكتبة، ونمرر لها الدور لتتحكم بظهور زر الرفع
    screens.add(GeneralLibraryScreen(role: widget.role));

    // الجميع يرى المساعد الذكي
    screens.add(AiAssistantScreen(role: widget.role)); // لاحظ حذفنا كلمة const ومررنا المتغير
    return screens;
  }

  // 3. دالة ذكية تحدد أزرار القائمة السفلية بناءً على الدور
  List<BottomNavigationBarItem> _getBottomNavItems() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
    ];

    if (widget.role == UserRole.student || widget.role == UserRole.teacher) {
      items.add(const BottomNavigationBarItem(icon: Icon(Icons.book), label: 'مقرراتي'));
    }

    items.add(const BottomNavigationBarItem(icon: Icon(Icons.local_library), label: 'المكتبة'));
    items.add(const BottomNavigationBarItem(icon: Icon(Icons.auto_awesome), label: 'المساعد'));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final screens = _getScreens();
    final navItems = _getBottomNavItems();

    // حماية لتجنب أخطاء الفهرس إذا تغير عدد الشاشات
    if (_currentIndex >= screens.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      drawer: CustomDrawer(role: widget.role),      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        items: navItems,
      ),
    );
  }
}