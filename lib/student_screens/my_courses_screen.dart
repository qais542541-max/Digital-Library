import 'package:flutter/material.dart';
import '../core/widgets/unified_item_card.dart';
import '../core/screens/course_details_screen.dart';
import '../core/widgets/custom_drawer.dart';



// 1. حولناها إلى StatefulWidget لكي تتغير الواجهة عند اختيار سنة أخرى
class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  // السنة الافتراضية المحددة
  String selectedYear = 'السنة الثالثة';

  // قائمة السنوات
  final List<String> years = ['السنة الأولى', 'السنة الثانية', 'السنة الثالثة', 'السنة الرابعة'];
  @override
  Widget build(BuildContext context) {

    // 🌐 [مكان ربط الـ API - PHP] : جلب مواد الترم الأول بناءً على السنة
    // ---------------------------------------------------------
    // مستقبلاً: عند تغيير السنة (selectedYear)، سنرسل قيمتها لملف الـ PHP
    // ليقوم بإرجاع المواد الخاصة بتلك السنة وهذا الترم تحديداً.
    final List<Map<String, String>> term1Courses = [
      {'title': 'إدارة المشاريع البرمجية ($selectedYear)', 'doctor': 'م. خالد'},
      {'title': 'جودة البرمجيات', 'doctor': 'د. فاطمة'},
      {'title': 'هياكل البيانات', 'doctor': 'م. عمر'},
    ];

    // 🌐 [مكان ربط الـ API - PHP] : جلب مواد الترم الثاني بناءً على السنة
    final List<Map<String, String>> term2Courses = [
      {'title': 'برمجة تطبيقات الهاتف', 'doctor': 'د. علي'},
      {'title': 'الذكاء الاصطناعي', 'doctor': 'د. سامي'},
      {'title': 'أمن المعلومات', 'doctor': 'م. أحمد'},
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // ---- هنا وضعنا أزرار السنوات (القائمة المنسدلة الذكية) ----
          title: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedYear,
              icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E7D32)),
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              items: years.map((String year) {
                return DropdownMenuItem<String>(
                  value: year,
                  child: Text(year),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedYear = newValue; // تحديث الشاشة فوراً عند اختيار سنة جديدة
                  });
                }
              },
            ),
          ),
          centerTitle: true,
          // --------------------------------------------------------
          bottom: const TabBar(
            labelColor: Color(0xFF2E7D32),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'الترم الأول'),
              Tab(text: 'الترم الثاني'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCoursesList(term1Courses),
            _buildCoursesList(term2Courses),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList(List<Map<String, String>> courses) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: UnifiedItemCard(
            title: courses[index]['title']!,
            subtitle: 'أستاذ المقرر: ${courses[index]['doctor']!}',
            icon: Icons.folder_special,
            isGridView: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsScreen(
                    // 🌐 [مكان ربط الـ API - PHP] : تمرير الـ ID الخاص بالمادة
                    courseTitle: courses[index]['title']!,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}