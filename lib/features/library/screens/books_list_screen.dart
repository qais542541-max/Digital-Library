import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/widgets/resource_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';
import 'package:digital_library/features/layout/screens/main_screen.dart';
import '../../../core/widgets/project_details_dialog.dart';
import '../../../core/widgets/smart_upload_bottom_sheet.dart';
import '../../../core/widgets/advanced_search_bottom_sheet.dart';

class BooksListScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int subjectId;
  final UserRole role;
  final bool isPublicLibrary;

  const BooksListScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.subjectId,
    required this.role,
    this.isPublicLibrary = false,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isProjectsCategory = widget.categoryName.trim() == 'books_list_screen.graduation_projects'.tr();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    // 👇 بيانات تجريبية موسعة تشمل حالة الإعارة للكتب الورقية
    final List<Map<String, dynamic>> mockBooks = [
      {
        'title': 'books_list_screen.intro_to_software_eng'.tr(),
        'author': 'books_list_screen.ian_sommerville'.tr(),
        'icon': Icons.menu_book,
        'shelf': 'A1 - قسم البرمجيات',
        'isBorrowed': false // متاح
      },
      {
        'title': 'books_list_screen.data_structures_algorithms'.tr(),
        'author': 'books_list_screen.robert_lafore'.tr(),
        'icon': Icons.menu_book,
        'shelf': 'A2 - قسم البرمجيات',
        'isBorrowed': true // معار
      },
      {
        'title': 'تصميم وتحليل النظم',
        'author': 'جيفري هوفر',
        'icon': Icons.menu_book,
        'shelf': 'B1 - نظم المعلومات',
        'isBorrowed': false // متاح
      },
      {
        'title': 'شبكات الحاسوب والاتصالات',
        'author': 'أندرو تانينباوم',
        'icon': Icons.menu_book,
        'shelf': 'C3 - قسم الشبكات',
        'isBorrowed': true // معار
      },
      {
        'title': 'أمن المعلومات والتشفير',
        'author': 'ويليام ستولينجز',
        'icon': Icons.menu_book,
        'shelf': 'C4 - قسم الأمن السيبراني',
        'isBorrowed': false // متاح
      },
    ];

    final List<Map<String, dynamic>> mockProjects = [
      {
        'title': 'books_list_screen.library_management_system'.tr(),
        'students': 'books_list_screen.students_names'.tr(),
        'supervisor': 'books_list_screen.khaled_al_shaibani'.tr(),
        'year': '2026',
        'description': 'books_list_screen.project_description'.tr(),
        'image': 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?q=80&w=1000&auto=format&fit=crop',
      },
    ];

    final displayList = isProjectsCategory ? mockProjects : mockBooks;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      drawer: CustomDrawer(role: widget.role),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : primaryGreen),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : primaryGreen,
            fontFamily: 'Cairo',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // شريط البحث والفلترة المتقدمة
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: primaryGreen, size: 20),
                    onPressed: () {
                      final isPhysicalLibrary = !widget.isPublicLibrary && !isProjectsCategory;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AdvancedSearchBottomSheet(isPhysicalLibrary: isPhysicalLibrary),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                    ),
                    child: TextField(
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14, fontFamily: 'Cairo'),
                      decoration: InputDecoration(
                        hintText: 'books_list_screen.search_hint'.tr(args: [widget.categoryName]),
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontFamily: 'Cairo'),
                        prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // قائمة المحتوى
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 80),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];
                final isPhysicalLibrary = !widget.isPublicLibrary && !isProjectsCategory;

                return ResourceItemCard(
                  title: item['title'],
                  subtitle: isProjectsCategory
                      ? 'books_list_screen.supervised_by'.tr(args: [item['supervisor'] ?? ''])
                      : (item['author'] ?? 'مؤلف غير معروف'),
                  icon: isProjectsCategory ? Icons.architecture : item['icon'],
                  role: UserRole.student,

                  // 👇 تمرير بيانات الرف وحالة الإعارة فقط إذا كانت المكتبة ورقية
                  shelfLocation: isPhysicalLibrary ? (item['shelf'] ?? 'الرف العام') : null,
                  isBorrowed: isPhysicalLibrary ? (item['isBorrowed'] ?? false) : null,

                  onTap: () {
                    if (isProjectsCategory) {
                      showDialog(
                        context: context,
                        builder: (context) => ProjectDetailsDialog(project: item),
                      );
                    } else if (isPhysicalLibrary) {
                      print("إظهار بيانات الكتاب الورقي");
                    } else {
                      print('books_list_screen.open_resource_msg'.tr(args: [item['title']]));
                    }
                  },
                  // إخفاء التنزيل للمكتبة الورقية والمشاريع
                  onDownload: (isPhysicalLibrary || isProjectsCategory)
                      ? null
                      : () => print('books_list_screen.downloading_msg'.tr(args: [item['title']])),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: widget.isPublicLibrary &&
          (widget.role == UserRole.student ||
              widget.role == UserRole.teacher ||
              widget.role == UserRole.employee)
          ? FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SmartUploadBottomSheet(
              categoryName: widget.categoryName,
              restriction: UploadRestriction.pdfOnly,
            ),
          );
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: Text('books_list_screen.upload_resource'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      )
          : null,
    );
  }
}