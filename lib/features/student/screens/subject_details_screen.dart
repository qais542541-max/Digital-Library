import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../library/screens/books_list_screen.dart'; // مسار شاشة عرض المحتوى


class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final int subjectId; // 👈 1. أضفنا هذا المتغير

  const SubjectDetailsScreen({
    Key? key,
    required this.subjectName,
    required this.subjectId, // 👈 2. طلبنا تمريره بشكل إلزامي هنا
  }) : super(key: key);

  // ... (باقي الكود كما هو)

  @override
  Widget build(BuildContext context) {

    // أضفنا 'id' لكل قسم لكي يفهمه الـ API لاحقاً
    final List<Map<String, dynamic>> subjectCategories = [
      {'id': 1, 'title': 'الملازم', 'icon': Icons.menu_book, 'subtitle': 'مذكرات وملخصات'},
      {'id': 2, 'title': 'المحاضرات', 'icon': Icons.ondemand_video, 'subtitle': 'شروحات وعروض'},
      {'id': 3, 'title': 'التكاليف', 'icon': Icons.assignment, 'subtitle': 'الواجبات العملية'},
      {'id': 4, 'title': 'النماذج', 'icon': Icons.quiz, 'subtitle': 'أسئلة وامتحانات'},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        title: Text(
          subjectName, // عرض اسم المادة في الأعلى
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: subjectCategories.length,
        itemBuilder: (context, index) {
          return UnifiedItemCard(
            title: subjectCategories[index]['title'],
            subtitle: subjectCategories[index]['subtitle'],
            icon: subjectCategories[index]['icon'],
            isGridView: true,
            // 👇 دالة onTap واحدة فقط وديناميكية تكفي لكل الأقسام!
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BooksListScreen(
                    // نأخذ اسم القسم ورقم القسم من المصفوفة بناءً على مكان الضغطة
                    categoryName: subjectCategories[index]['title'],
                    categoryId: subjectCategories[index]['id'],
                    subjectId: subjectId, // رقم المادة الثابت الذي استقبلته الشاشة
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}