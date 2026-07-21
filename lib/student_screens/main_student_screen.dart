import 'package:flutter/material.dart';
import 'my_courses_screen.dart';
import '../core/screens/general_library_screen.dart'; // شاشة المكتبة العامة
import 'ai_assistant_screen.dart';
import '../core/screens/general_main_screen.dart';// مسار الشاشة الرئيسية الجديدة المشتركة
import '../core/widgets/custom_drawer.dart';//استدعاء ملف ايقونة القائمة الجانبية


class MainStudentScreen extends StatefulWidget {
  const MainStudentScreen({super.key});

  @override
  State<MainStudentScreen> createState() => _MainStudentScreenState();
}

class _MainStudentScreenState extends State<MainStudentScreen> {
  // المؤشر 0 لكي يفتح التطبيق مباشرة على "الرئيسية"
  int _currentIndex = 0;

  // الترتيب الجديد للشاشات مع إرسال بياناتك الديناميكية
  final List<Widget> _screens = [
    // 0. الرئيسية (الشاشة المشتركة التي أنشأناها)
    const GeneralMainScreen(
      userName: 'عمار العقبي', // إرسال اسم الطالب
      userRole: 'طالب - المستوى الثالث', // إرسال الصفة
    ),
    // 1. مقرراتي
    const MyCoursesScreen(),
    // 2. المكتبة العامة
    const GeneralLibraryScreen(),
    // 3. المساعد الذكي
    const AiAssistantScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // هام لمنع اختفاء الألوان
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'مقرراتي',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: 'المكتبة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'المساعد',
          ),
        ],
      ),
    );
  }
}