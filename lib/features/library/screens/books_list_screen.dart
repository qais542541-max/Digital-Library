import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/custom_drawer.dart'; // 👈 استدعاء القائمة الجانبية
import '../../layout/screens/main_screen.dart';
import '../../../core/widgets/project_details_dialog.dart';

class BooksListScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int subjectId;
  final UserRole role;

  const BooksListScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.subjectId,
    required this.role,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isProjectsCategory = widget.categoryName.trim() == 'مشاريع التخرج';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const Color primaryGreen = Color(0xFF2E7D32);

    final List<Map<String, dynamic>> mockBooks = [
      {'title': 'مقدمة في هندسة البرمجيات', 'author': 'د. إيان سومرفيل', 'icon': Icons.menu_book},
      {'title': 'هياكل البيانات والخوارزميات', 'author': 'د. روبرت لايفور', 'icon': Icons.library_books},
    ];

    final List<Map<String, dynamic>> mockProjects = [
      {
        'title': 'نظام إدارة مكتبة كلية المجتمع',
        'students': 'أحمد سعيد، يوسف أحمد',
        'supervisor': 'د. خالد الشيباني',
        'year': '2026',
        'description': 'نظام متكامل لإدارة الموارد الأكاديمية والكتب الإلكترونية والمشاريع السابقة، مع نظام صلاحيات يفصل بين الطلاب والمعلمين، مبني باستخدام Flutter و PHP.',
        // يمكنك وضع رابط صورة حقيقي من الإنترنت، أو مسار محلي 'assets/images/project1.png'
        'image': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=1000&auto=format&fit=crop',
      },
      // ... المشروع الثاني ...
    ];

    final displayList = isProjectsCategory ? mockProjects : mockBooks;

    return Scaffold(
      // 👇 1. إعادة ربط القائمة الجانبية بالشاشة
      drawer: CustomDrawer(role: widget.role),

      appBar: AppBar(
        elevation: 0,
        // 👇 2. زر الرجوع في مكانه الطبيعي (اليمين في اللغة العربية)
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        // 👇 3. إضافة زر القائمة الجانبية في الجهة المقابلة (اليسار)
        actions: [
          Builder( // نستخدم Builder للحصول على الـ context الخاص بـ Scaffold لفتح القائمة
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : primaryGreen),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // شريط بحث فرعي داخل القسم
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
              ),
              child: TextField(
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14),
                decoration: InputDecoration(
                  hintText: isArabic ? 'ابحث في ${widget.categoryName}...' : 'Search in ${widget.categoryName}...',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // قائمة المحتوى
          // تأكد من استدعاء ملف النافذة المنبثقة في أعلى الملف
          // import 'مسار_الملف/project_details_dialog.dart';

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: UnifiedItemCard(
                    title: item['title'],
                    // إذا كان مشروعاً نعرض اسم المشرف كعنوان فرعي، وإلا نعرض اسم المؤلف
                    subtitle: isProjectsCategory ? 'إشراف: ${item['supervisor']}' : item['author'],
                    // تعيين أيقونة مميزة للمشاريع
                    icon: isProjectsCategory ? Icons.architecture : item['icon'],
                    isGridView: false,
                    onTap: () {
                      // 👇 إذا كان قسم مشاريع، نعرض النافذة المنبثقة الاحترافية
                      if (isProjectsCategory) {
                        showDialog(
                          context: context,
                          builder: (context) => ProjectDetailsDialog(project: item),
                        );
                      }
                      // 👇 وإلا، نفتح الكتاب مباشرة أو ننقله لشاشة القراءة
                      else {
                        print('فتح الكتاب المعتاد: ${item['title']}');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: (widget.role == UserRole.teacher || widget.role == UserRole.employee)
          ? FloatingActionButton.extended(
        onPressed: () {
          print('فتح واجهة رفع ملف للقسم: ${widget.categoryName}');
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: const Text('رفع مرجع', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null,
    );
  }

  // ==========================================
  // تصميم البطاقة المخصصة لمشاريع التخرج
  // ==========================================
  Widget _buildProjectCard(Map<String, dynamic> project, bool isDarkMode, Color primaryGreen) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            print('فتح تفاصيل المشروع: ${project['title']}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.architecture, color: primaryGreen, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'دفعة ${project['year']}',
                              style: TextStyle(fontSize: 11, color: isDarkMode ? Colors.grey.shade300 : Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),

                Row(
                  children: [
                    const Icon(Icons.group, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'إعداد: ${project['students']}',
                        style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'إشراف: ${project['supervisor']}',
                        style: TextStyle(fontSize: 13, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}