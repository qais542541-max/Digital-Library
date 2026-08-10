import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';

// ملاحظة: لم نعد بحاجة لاستدعاء BooksListScreen هنا لأن المحتوى سيظهر داخل التوب بار

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final int subjectId;

  const SubjectDetailsScreen({
    Key? key,
    required this.subjectName,
    required this.subjectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // الأقسام الأربعة، احتفظنا بالـ id لربطه بالـ API لاحقاً
    final List<Map<String, dynamic>> subjectCategories = [
      {'id': 1, 'title': 'الملازم', 'icon': Icons.menu_book},
      {'id': 2, 'title': 'المحاضرات', 'icon': Icons.ondemand_video},
      {'id': 3, 'title': 'التكاليف', 'icon': Icons.assignment},
      {'id': 4, 'title': 'النماذج', 'icon': Icons.quiz},
    ];

    // استخدام DefaultTabController لإنشاء التوب بار بعدد الأقسام (4)
    return DefaultTabController(
      length: subjectCategories.length,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: const Color(0xFF2E7D32),
          elevation: 0,
          title: Text(
            subjectName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),

          // 👇 إنشاء التوب بار هنا 👇
          bottom: TabBar(
            isScrollable: true, // يسمح بسحب التبويبات إذا كانت الشاشة صغيرة
            labelColor: Colors.white, // لون النص للقسم المحدد
            unselectedLabelColor: Colors.white70, // لون النص للقسم غير المحدد
            indicatorColor: Colors.white, // لون الخط تحت القسم
            indicatorWeight: 3,
            tabs: subjectCategories.map((category) {
              return Tab(
                text: category['title'],
              );
            }).toList(),
          ),
        ),

        // 👇 المحتوى الذي يتغير بتغير القسم في التوب بار 👇
        body: TabBarView(
          children: subjectCategories.map((category) {
            // نمرر الـ id واسم القسم لبناء القائمة الخاصة به
            return _buildCategoryContent(category['id'], category['title'], category['icon']);
          }).toList(),
        ),
      ),
    );
  }

  // دالة بناء محتوى كل قسم (قائمة الموارد الخاصة به)
  Widget _buildCategoryContent(int categoryId, String categoryName, IconData categoryIcon) {

    // 🌐 [مكان ربط الـ API - PHP]
    // لاحقاً، سنستخدم subjectId و categoryId هنا لجلب الملفات من قاعدة البيانات

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // عدد عناصر وهمي للتجربة
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: UnifiedItemCard(
            title: '$categoryName ${index + 1}', // يعرض مثلاً: ملزمة 1، محاضرة 2
            subtitle: 'انقر لفتح المورد',
            icon: categoryIcon,
            isGridView: false, // 👈 جعلناها false لتظهر كقائمة منسقة تحت بعضها
            onTap: () {
              // هنا سنضع كود فتح ملف الـ PDF أو تشغيل الفيديو مستقبلاً
              debugPrint('تم الضغط على $categoryName رقم ${index + 1}');
            },
          ),
        );
      },
    );
  }
}