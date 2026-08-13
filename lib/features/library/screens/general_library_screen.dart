import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import 'books_list_screen.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../layout/screens/main_screen.dart'; // 👈 1. استدعاء ملف الـ enum

class GeneralLibraryScreen extends StatelessWidget {
  final UserRole role; // 👈 2. استقبال دور المستخدم

  const GeneralLibraryScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // القوائم كما هي بدون تغيير...
    final List<Map<String, dynamic>> collegeLibraryCategories = [
      {'title': 'مشاريع التخرج', 'icon': Icons.account_tree, 'subtitle': 'أرشيف مشاريع الدفع السابقة'},
      // ... باقي الأقسام
    ];

    final List<Map<String, dynamic>> publicLibraryCategories = [
      {'title': 'مراجع برمجية وتقنية', 'icon': Icons.computer, 'subtitle': 'كتب ولغات برمجة'},
      // ... باقي الأقسام
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('المكتبة الشاملة', style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
          bottom: const TabBar(
            labelColor: Color(0xFF2E7D32),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E7D32),
            tabs: [Tab(text: 'مكتبة الكلية'), Tab(text: 'المكتبة العامة')],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
            ),
          ],
        ),
        drawer: CustomDrawer(role: role),        body: TabBarView(
          children: [
            _buildLibraryGrid(context, collegeLibraryCategories),
            _buildLibraryGrid(context, publicLibraryCategories),
          ],
        ),
        // 👈 تم حذف زر الرفع من هنا (FloatingActionButton) ونقله للداخل[cite: 1]
      ),
    );
  }

  Widget _buildLibraryGrid(BuildContext context, List<Map<String, dynamic>> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return UnifiedItemCard(
          title: categories[index]['title'],
          subtitle: categories[index]['subtitle'],
          icon: categories[index]['icon'],
          isGridView: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooksListScreen(
                  categoryName: categories[index]['title'],
                  categoryId: 5,
                  subjectId: 0,
                  role: role, // 👈 3. نمرر صلاحية المستخدم لشاشة القسم من الداخل
                ),
              ),
            );
          },
        );
      },
    );
  }
}