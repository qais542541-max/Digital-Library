import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../layout/screens/main_screen.dart'; // 👈 1. استدعاء ملف الـ enum

class SubjectDetailsScreen extends StatelessWidget {
  final String subjectName;
  final int subjectId;
  final UserRole role; // 👈 2. استقبال الدور

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
    required this.subjectId,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> subjectCategories = [
      {'id': 1, 'title': 'الملازم', 'icon': Icons.menu_book},
      {'id': 2, 'title': 'المحاضرات', 'icon': Icons.ondemand_video},
      {'id': 3, 'title': 'التكاليف', 'icon': Icons.assignment},
      {'id': 4, 'title': 'النماذج', 'icon': Icons.quiz},
    ];

    return DefaultTabController(
      length: subjectCategories.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(subjectName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: subjectCategories.map((c) => Tab(text: c['title'])).toList(),
          ),
        ),

        body: TabBarView(
          children: subjectCategories.map((category) {
            return _buildCategoryContent(category['id'], category['title'], category['icon']);
          }).toList(),
        ),

        // 👈 3. إظهار زر الرفع العائم للمعلم فقط
        floatingActionButton: role == UserRole.teacher
            ? FloatingActionButton.extended(
          onPressed: () {
            print('فتح واجهة الرفع الخاصة بالمعلم للمادة: $subjectName');
          },
          backgroundColor: const Color(0xFF2E7D32),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('رفع مورد جديد', style: TextStyle(color: Colors.white)),
        )
            : null,
      ),
    );
  }

  Widget _buildCategoryContent(int categoryId, String categoryName, IconData categoryIcon) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                child: UnifiedItemCard(
                  title: '$categoryName ${index + 1}',
                  subtitle: 'انقر لفتح المورد',
                  icon: categoryIcon,
                  isGridView: false,
                  onTap: () {
                    debugPrint('تم الضغط على $categoryName');
                  },
                ),
              ),
              // 👈 4. إظهار خيارات (تعديل / حذف) للمعلم فقط
              if (role == UserRole.teacher)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'edit') {
                      debugPrint('تعديل المورد');
                    } else if (value == 'delete') {
                      debugPrint('حذف المورد');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, color: Colors.blue, size: 20), SizedBox(width: 8), Text('تعديل')])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('حذف')])),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}