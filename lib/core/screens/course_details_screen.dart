import 'package:flutter/material.dart';
import '../widgets/unified_item_card.dart';
import '../widgets/custom_drawer.dart';

// تذكر تعديل مسار استدعاء شاشة الـ PDF إذا لزم الأمر بناءً على مكانها الجديد
import '../../student_screens/pdf_viewer_screen.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseTitle;
  // أضفنا هذا المفتاح السحري: هل المستخدم مدرس؟ (الافتراضي: لا)
  final bool isTeacher;

  const CourseDetailsScreen({
    super.key,
    required this.courseTitle,
    this.isTeacher = false, // نجعلها false افتراضياً لكي لا يحصل الطالب على الصلاحية بالخطأ
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
          title: Text(
            courseTitle,
            style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color(0xFF2E7D32),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'الملازم والمقررات'),
              Tab(text: 'التكاليف والمهام'),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body: TabBarView(
          children: [
            _buildContentList('ملزمة', Icons.picture_as_pdf),
            _buildContentList('تكليف', Icons.assignment),
          ],
        ),

        // هنا يحدث السحر الهندسي: زر الرفع العائم
        // إذا كان المستخدم مدرساً (true) نرسم الزر، وإذا كان طالباً (false) نضع null لكي يختفي
        floatingActionButton: isTeacher
            ? FloatingActionButton.extended(
          onPressed: () {
            // هنا سيتم فتح واجهة اختيار ملف من الهاتف لرفعه
            print('فتح واجهة رفع ملف جديد لمادة $courseTitle');
          },
          backgroundColor: const Color(0xFF1565C0), // لون أزرق مميز للمدرس
          icon: const Icon(Icons.upload_file, color: Colors.white),
          label: const Text('رفع ملف', style: TextStyle(color: Colors.white)),
        )
            : null,
      ),
    );
  }

  // دالة بناء محتوى المادة (تبقى كما هي للجميع، فالتنزيل متاح للكل)
  Widget _buildContentList(String itemName, IconData icon) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: UnifiedItemCard(
            title: '$itemName ${index + 1}',
            subtitle: 'تم الرفع مؤخراً',
            icon: icon,
            isGridView: false,
            onTap: () {
              // كود فتح الـ PDF
            },
            onDownload: () {
              print('بدء تنزيل: $itemName ${index + 1}');
            },
          ),
        );
      },
    );
  }
}