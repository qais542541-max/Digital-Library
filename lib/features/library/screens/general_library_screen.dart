import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../layout/screens/main_screen.dart';
import 'books_list_screen.dart';

class GeneralLibraryScreen extends StatelessWidget {
  final UserRole role;

  const GeneralLibraryScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final isArabic = settings.languageCode == 'ar';
    const Color primaryGreen = Color(0xFF2E7D32);

    // قوائم الأقسام
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
      child: SafeArea( // لضمان عدم تداخل الترويسة مع شريط حالة الهاتف
        child: Column(
          children: [
            // 👇 1. ترويسة الشاملة المخصصة (نص ثابت في المنتصف بدلاً من القائمة المنسدلة) 👇
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // زر القائمة الجانبية
                  IconButton(
                    icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),

                  // النص الثابت
                  Text(
                    isArabic ? 'المكتبة العامة' : 'General Library',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : primaryGreen,
                      fontFamily: 'Cairo', // للحصول على مظهر أنيق للنص
                    ),
                  ),

                  // زر الإشعارات
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                  ),
                ],
              ),
            ),

            // 👇 2. شريط البحث المتقدم (Shamela Style) 👇
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Row(
                children: [
                  // زر البحث المتقدم (منفصل)
                  Container(
                    height: 45, // نفس ارتفاع شريط البحث
                    width: 45,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: primaryGreen, size: 20),
                      onPressed: () {
                        // TODO: إظهار نافذة البحث المتقدم
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // مسافة بين الزر وشريط البحث

                  // شريط البحث الأساسي
                  Expanded(
                    child: Container(
                      height: 45, // 👈 تحديد ارتفاع نحيف للشريط
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                      ),
                      child: TextField(
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: isArabic ? 'ابحث عن مقرر...' : 'Search for course...',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20), // 👈 أيقونة أصغر
                          border: InputBorder.none,
                          isDense: true, // 👈 يجعل الحقل مدمجاً أكثر
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 👇 3. شريط التبويبات المدمج (مكتبة الكلية / المكتبة العامة) 👇
            Container(
              color: Colors.transparent,
              child: TabBar(
                dividerColor: Colors.transparent, // 👈 إزالة الخط الرمادي من هنا
                labelColor: primaryGreen,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryGreen,
                tabs: [
                  Tab(text: isArabic ? 'مكتبة الكلية' : 'College Library'),
                  Tab(text: isArabic ? 'المكتبة العامة' : 'Public Library'),
                ],
              ),
            ),

            // 👇 4. عرض محتوى التبويبات (شكل شبكي - Grid) 👇
            Expanded(
              child: TabBarView(
                children: [
                  _buildLibraryGrid(context, collegeLibraryCategories),
                  _buildLibraryGrid(context, publicLibraryCategories),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // بناء شبكة الأقسام باستخدام UnifiedItemCard الموحدة
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
            // إعادة الاستخدام: التوجيه لشاشة BooksListScreen الموحدة
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooksListScreen(
                  categoryName: categories[index]['title'],
                  categoryId: 5, // مررنا ID افتراضي للقسم
                  subjectId: 0,  // 0 يعني أننا لا نبحث داخل مقرر دراسي
                  role: role,    // تمرير الصلاحية
                ),
              ),
            );
          },
        );
      },
    );
  }
}