import 'package:flutter/material.dart';
import '../core/widgets/unified_item_card.dart';
import '../core/screens/course_details_screen.dart'; // للانتقال إلى شاشة الملازم النهائية

class YearDetailsScreen extends StatelessWidget {
  final String yearName; // تستقبل اسم السنة من الشاشة السابقة

  const YearDetailsScreen({super.key, required this.yearName});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية لمواد كل ترم
    final List<String> term1Courses = ['إدارة المشاريع البرمجية', 'جودة البرمجيات', 'هياكل البيانات'];
    final List<String> term2Courses = ['تطبيقات الهاتف المحمول', 'الذكاء الاصطناعي', 'أمن المعلومات'];

    return DefaultTabController(
      length: 2, // عدد التبويبات (ترمين)
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
          title: Text(
            yearName, // يعرض (السنة الأولى، الثانية، أو الثالثة) في الأعلى
            style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
            // محتوى الترم الأول
            _buildCoursesList(context, term1Courses),
            // محتوى الترم الثاني
            _buildCoursesList(context, term2Courses),
          ],
        ),
      ),
    );
  }

  // دالة لبناء قائمة المواد وتجهيزها للانتقال لشاشة الملازم
  Widget _buildCoursesList(BuildContext context, List<String> courses) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: UnifiedItemCard(
            title: courses[index],
            subtitle: 'عرض التفاصيل والملازم',
            icon: Icons.menu_book,
            isGridView: false,
            onTap: () {
              // الدخول إلى عمق المادة (الملازم والتكاليف)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsScreen(courseTitle: courses[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}