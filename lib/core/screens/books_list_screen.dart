import 'package:flutter/material.dart';
// استدعاء شاشة قارئ الـ PDF
import '../../student_screens/pdf_viewer_screen.dart';
// استدعاء البطاقة الموحدة
import '../widgets/unified_item_card.dart';

import '../widgets/custom_drawer.dart';
//استدعاء ايقونة القائمة الجانبية


class BooksListScreen extends StatefulWidget {
  final String categoryName;

  const BooksListScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  @override
  Widget build(BuildContext context) {
    // التحقق مما إذا كان القسم الحالي هو قسم المشاريع
    final bool isProjectsCategory = widget.categoryName == 'مشاريع التخرج';

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: isProjectsCategory ? 'ابحث عن مشروع تخرج أو تقنية...' : 'ابحث عن كتاب أو ملف...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.swap_vert, color: Color(0xFF2E7D32)),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),

          // 2. شريط الإحصائيات والترتيب
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isProjectsCategory ? 'أحدث المشاريع المضافة' : 'الكتب مرتبة (أبجدياً)',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                // 🌐 [مكان ربط الـ API - PHP] : طباعة العدد الفعلي للملفات في هذا القسم
                const Text(
                  'العدد: 24',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
          ),

          // 3. قائمة الملفات
          Expanded(
            // 🌐 [مكان ربط الـ API - PHP] : استخدام FutureBuilder هنا لجلب الملفات الخاصة بهذا القسم
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4, // عدد وهمي مؤقت
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
                        // فتح النافذة السفلية بدلاً من الانتقال المباشر
                        _showProjectDetailsBottomSheet(context);
                      },
                      // إخفاء زر التنزيل من البطاقة الخارجية
                      onDownload: null,
                    ),
                  );
                }
                // حالة الكتب والمراجع العادية
                else {
                  return _buildBookCard(
                    title: 'عنوان الكتاب أو الملزمة رقم ${index + 1}',
                    author: 'المؤلف: د. أحمد / م. خالد',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء بطاقة الكتاب بنفس تصميم (المكتبة الشاملة)
  Widget _buildBookCard({required String title, required String author}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            author,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.download_outlined, color: Colors.grey, size: 26),
          onPressed: () {
            // 🌐 [مكان ربط الـ API - PHP] : كود استدعاء رابط تنزيل الملف
            print('تم الضغط على تنزيل: $title');
          },
        ),
        onTap: () {
          // فتح الـ PDF مباشرة للقراءة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(
                pdfTitle: title, // نمرر عنوان الكتاب الحالي الذي ضغط عليه المستخدم
                pdfUrl: 'https://example.com/dummy.pdf', // 🌐 [مكان ربط الـ API] : رابط وهمي مؤقت
              ),
            ),
          );
        },
      ),
    );
  }

  // --- دالة النافذة السفلية (Bottom Sheet) لمشاريع التخرج ---
  void _showProjectDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                    color: Colors.grey.shade300,
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
                  color: Colors.grey.shade100,
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

              // 🌐 [مكان ربط الـ API - PHP] : قائمة بأسماء فريق العمل (يتم جلبها كمصفوفة List)
              const Text(
                'فريق العمل:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // استخدام Wrap لترتيب الأسماء تلقائياً في السطور
              Wrap(
                spacing: 8.0, // المسافة الأفقية بين الأسماء
                runSpacing: 8.0, // المسافة العمودية عند النزول لسطر جديد
                children: ['عمار العقبي', 'يوسف شمسان', 'هاشم العباهي'].map((studentName) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20), // جعل الحواف دائرية كأنها أوسمة
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, size: 16, color: Color(0xFF2E7D32)),
                        const SizedBox(width: 6),
                        Text(
                          studentName,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 4),
              Text(
                'إشراف: د. مجدي السياني',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const Divider(height: 24),

              // 🌐 [مكان ربط الـ API - PHP] : وصف المشروع
              const Text(
                'نبذة عن المشروع:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'نظام متكامل يجمع بين إدارة المكتبة المادية وتوفير مصادر رقمية للطلاب، يوفر صلاحيات متعددة لتسهيل العملية التعليمية.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 24),

              // أزرار الإجراءات
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // إغلاق النافذة السفلية أولاً
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PdfViewerScreen(
                              pdfTitle: 'نظام إدارة مكتبة هجين', // عنوان المشروع الثابت مؤقتاً
                              pdfUrl: 'https://example.com/dummy_project.pdf', // 🌐 [مكان ربط الـ API] : رابط وهمي مؤقت
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
                        // 🌐 [مكان ربط الـ API - PHP] : كود استدعاء رابط تنزيل ملفات المشروع
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