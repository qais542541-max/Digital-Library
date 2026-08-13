import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';
import 'subject_details_screen.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../layout/screens/main_screen.dart'; // 👈 1. استدعاء ملف الـ enum

class MyCoursesScreen extends StatelessWidget {
  final UserRole role; // 👈 2. استقبال دور المستخدم من الشاشة الرئيسية

  const MyCoursesScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final selectedYear = settings.academicYear;

    final List<String> years = ['السنة الأولى', 'السنة الثانية', 'السنة الثالثة', 'السنة الرابعة'];

    // القوائم المؤقتة...
    final List<Map<String, dynamic>> term1Courses = [
      {'id': 1, 'title': 'إدارة المشاريع البرمجية ($selectedYear)', 'doctor': 'م. خالد', 'icon': Icons.computer},
      // ... باقي المواد
    ];
    final List<Map<String, dynamic>> term2Courses = [
      {'id': 4, 'title': 'برمجة تطبيقات الهاتف', 'doctor': 'د. علي', 'icon': Icons.phone_android},
      // ... باقي المواد
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: settings.academicTermIndex,
      child: Scaffold(
        drawer: CustomDrawer(role: role),        appBar: AppBar(
          // ... نفس إعدادات الـ AppBar السابقة تماماً[cite: 3]
          elevation: 0,
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

  Widget _buildCoursesList(List<Map<String, dynamic>> courses) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final subject = courses[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectDetailsScreen(
                    subjectName: subject['title'],
                    subjectId: subject['id'],
                    role: role, // 👈 3. تمرير الصلاحية لشاشة تفاصيل المادة
                  ),
                ),
              );
            },
            child: UnifiedItemCard(
              title: subject['title'],
              subtitle: subject['doctor'],
              icon: subject['icon'],
              isGridView: true,
            ),
          ),
        );
      },
    );
  }
}