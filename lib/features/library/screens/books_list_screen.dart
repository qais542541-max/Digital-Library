import 'package:flutter/material.dart';
// استدعاء شاشة قارئ الـ PDF
import 'pdf_viewer_screen.dart';
// استدعاء البطاقة الموحدة
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';

class BooksListScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int subjectId;

  const BooksListScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.subjectId,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. استخدام trim() لمنع مشاكل المسافات التي تخفي البطاقة
    final bool isProjectsCategory = widget.categoryName.trim() == 'مشاريع التخرج';

    // قراءة حالة الوضع المظلم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const CustomDrawer(),
      // 2. إزالة اللون الأبيض الثابت لكي تعمل الشاشة مع الوضع المظلم
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
        title: Text(
          widget.categoryName,
          // إزالة تحديد اللون هنا ليتكيف مع الثيم تلقائياً
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: isProjectsCategory ? 'ابحث عن مشروع تخرج أو تقنية...' : 'ابحث عن كتاب أو ملف...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.swap_vert, color: Color(0xFF2E7D32)),
                filled: true,
                // تكييف لون حقل البحث مع الوضع المظلم
                fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // شريط الإحصائيات والترتيب
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isProjectsCategory ? 'أحدث المشاريع المضافة' : 'الكتب مرتبة (أبجدياً)',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Text(
                  'العدد: 24',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
          ),

          // قائمة الملفات
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (context, index) {

                // حالة قسم مشاريع التخرج
                if (isProjectsCategory) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: UnifiedItemCard(
                      title: 'نظام إدارة مكتبة هجين',
                      subtitle: 'سنة المناقشة: 2026',
                      icon: Icons.school,
                      isGridView: false,
                      onTap: () {
                        // تمرير حالة الوضع المظلم للنافذة السفلية
                        _showProjectDetailsBottomSheet(context, isDarkMode);
                      },
                      onDownload: null,
                    ),
                  );
                }

                // حالة الكتب والمراجع العادية
                else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: UnifiedItemCard(
                      title: 'عنوان الكتاب أو الملزمة رقم ${index + 1}',
                      subtitle: 'المؤلف: د. أحمد / م. خالد',
                      icon: Icons.menu_book,
                      isGridView: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfTitle: 'عنوان الكتاب أو الملزمة رقم ${index + 1}',
                              pdfUrl: 'https://example.com/dummy.pdf',
                            ),
                          ),
                        );
                      },
                      onDownload: () {
                        print('تم الضغط على تنزيل الكتاب رقم ${index + 1}');
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- دالة النافذة السفلية لمشاريع التخرج (تم تكييفها للوضع المظلم) ---
  void _showProjectDetailsBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مؤشر السحب
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // صورة الغلاف
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.account_tree, size: 60, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // عنوان المشروع
              const Text(
                'نظام إدارة مكتبة هجين',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'فريق العمل:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: ['عمار العقبي', 'يوسف شمسان', 'هاشم العباهي'].map((studentName) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, size: 16, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 6),
                        Text(
                          studentName,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 4),
              const Text(
                'إشراف: د. مجدي السياني',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(height: 24),

              Text(
                'نبذة عن المشروع:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 8),
              const Text(
                'نظام متكامل يجمع بين إدارة المكتبة المادية وتوفير مصادر رقمية للطلاب، يوفر صلاحيات متعددة لتسهيل العملية التعليمية مع وجود ميزة الاختبارات الرقمية.',
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PdfViewerScreen(
                              pdfTitle: 'نظام إدارة مكتبة هجين',
                              pdfUrl: 'https://example.com/dummy_project.pdf',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.menu_book, color: Colors.white),
                      label: const Text('قراءة البحث', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        print('بدء تنزيل ملفات المشروع...');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.download, color: Color(0xFF2E7D32)),
                      label: const Text('تنزيل', style: TextStyle(color: Color(0xFF2E7D32))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}