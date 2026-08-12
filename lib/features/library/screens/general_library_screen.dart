import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import 'books_list_screen.dart'; // استدعاء شاشة قائمة الكتب الجديدة
import '../../../core/widgets/custom_drawer.dart'; // 👈 1. استدعاء ملف القائمة الجانبية هنا
import '../../../core/widgets/notifications_screen.dart'; // استدعاء ملف ايقونة القائمة الجانبية


class GeneralLibraryScreen extends StatelessWidget {
  const GeneralLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> collegeLibraryCategories = [
      {'title': 'مشاريع التخرج', 'icon': Icons.account_tree, 'subtitle': 'أرشيف مشاريع الدفع السابقة'},
      {'title': 'نماذج امتحانات', 'icon': Icons.quiz, 'subtitle': 'أسئلة السنوات الماضية'},
      {'title': 'أبحاث متميزة', 'icon': Icons.star, 'subtitle': 'أفضل تكاليف الطلاب'},
      {'title': 'أدلة الكلية', 'icon': Icons.info, 'subtitle': 'اللوائح والخطط الدراسية'},
    ];

    final List<Map<String, dynamic>> publicLibraryCategories = [
      {'title': 'مراجع برمجية وتقنية', 'icon': Icons.computer, 'subtitle': 'كتب ولغات برمجة'},
      {'title': 'ريادة أعمال وتسويق', 'icon': Icons.storefront, 'subtitle': 'إدارة المشاريع الرقمية'},
      {'title': 'تطوير الذات', 'icon': Icons.trending_up, 'subtitle': 'إنتاجية وإدارة وقت'},
      {'title': 'لغات أجنبية', 'icon': Icons.language, 'subtitle': 'قواميس ومراجع إنجليزية'},
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(

          elevation: 0,
          title: const Text(
            'المكتبة الشاملة',
            style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          // تم تغيير لون أيقونة القائمة (Drawer Icon) الافتراضية لتتناسب مع لون الشريط
          iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
          bottom: const TabBar(
            labelColor: Color(0xFF2E7D32),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'مكتبة الكلية'),
              Tab(text: 'المكتبة العامة'),
            ],
          ),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),

        // 👈 2. إضافة القائمة الجانبية هنا ليتم ربطها بالشاشة
        drawer: const CustomDrawer(),

        body: TabBarView(
          children: [
            _buildLibraryGrid(context, collegeLibraryCategories),
            _buildLibraryGrid(context, publicLibraryCategories),
          ],
        ),

        // زر الرفع المشترك
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            print('فتح واجهة رفع ملف لمراجعته من قبل إدارة المكتبة');
          },
          backgroundColor: const Color(0xFF2E7D32),
          icon: const Icon(Icons.cloud_upload, color: Colors.white),
          label: const Text('مشاركة مرجع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // تمرير الـ context كمتغير هنا لكي يتعرف عليه الـ Navigator
  Widget _buildLibraryGrid(BuildContext context, List<Map<String, dynamic>> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return UnifiedItemCard(
          title: categories[index]['title'],
          subtitle: categories[index]['subtitle'],
          icon: categories[index]['icon'],
          isGridView: true,
          onTap: () {
            // كود الانتقال الصحيح إلى شاشة الكتب
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooksListScreen(
                  categoryName: categories[index]['title'], // ✅ هكذا يأخذ اسم القسم الحقيقي (مثل: مشاريع التخرج) // مثال
                  categoryId: 5, // مثال لرقم التصنيف
                  subjectId: 0, // 👈 أضف هذا السطر هنا أيضاً
                ),
              ),
            );
          },
        );
      },
    );
  }
}