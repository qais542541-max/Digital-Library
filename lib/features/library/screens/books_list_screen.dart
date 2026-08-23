import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/widgets/resource_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../layout/screens/main_screen.dart';
import '../../../core/widgets/project_details_dialog.dart';
import '../../../core/widgets/smart_upload_bottom_sheet.dart';

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

    // بيانات تجريبية
    final List<Map<String, dynamic>> mockBooks = [
      {
        'title': 'books_list_screen.intro_to_software_eng'.tr(),
        'author': 'books_list_screen.ian_sommerville'.tr(),
        'icon': Icons.menu_book
      },
      {
        'title': 'books_list_screen.data_structures_algorithms'.tr(),
        'author': 'books_list_screen.robert_lafore'.tr(),
        'icon': Icons.picture_as_pdf
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
          // شريط البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
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

          // قائمة المحتوى
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 80),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final item = displayList[index];

                return ResourceItemCard(
                  title: item['title'],
                  subtitle: isProjectsCategory 
                      ? 'books_list_screen.supervised_by'.tr(args: [item['supervisor']]) 
                      : item['author'],
                  icon: isProjectsCategory ? Icons.architecture : item['icon'],

                  // 👇 إخفاء الثلاث نقاط تماماً عن الجميع داخل المكتبة بتمرير UserRole.student
                  role: UserRole.student,

                  onTap: () {
                    if (isProjectsCategory) {
                      showDialog(
                        context: context,
                        builder: (context) => ProjectDetailsDialog(project: item),
                      );
                    } else {
                      print('books_list_screen.open_resource_msg'.tr(args: [item['title']]));
                    }
                  },
                  onDownload: () => print('books_list_screen.downloading_msg'.tr(args: [item['title']])),
                );
              },
            ),
          ),
        ],
      ),

      // 👇 ظهور زر الرفع في المكتبة العامة فقط للموظفين والمدرسين والطلاب
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
