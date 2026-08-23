import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../layout/screens/main_screen.dart';
import '../../../core/widgets/resource_item_card.dart';
import '../../../core/widgets/smart_upload_bottom_sheet.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final String subjectName;
  final int subjectId;
  final UserRole role;

  const SubjectDetailsScreen({
    super.key,
    required this.subjectName,
    required this.subjectId,
    required this.role,
  });

  @override
  // 1. تمت إضافة SingleTickerProviderStateMixin هنا 👇
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> with SingleTickerProviderStateMixin {
  // 2. تعريف متحكم التبويبات هنا 👇
  late TabController _tabController;

  final List<Map<String, dynamic>> subjectCategories = [
    {'id': 1, 'title': 'subject_details_screen.handouts', 'icon': Icons.menu_book},
    {'id': 2, 'title': 'subject_details_screen.lectures', 'icon': Icons.ondemand_video},
    {'id': 4, 'title': 'subject_details_screen.forms', 'icon': Icons.quiz},
  ];

  // 3. تهيئة المتحكم عند فتح الشاشة 👇
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: subjectCategories.length, vsync: this);
  }

  // 4. إغلاق المتحكم لتنظيف الذاكرة عند الخروج 👇
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation(String itemTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('subject_details_screen.delete_confirmation_title'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
        content: Text('subject_details_screen.delete_confirmation_message'.tr(args: [itemTitle])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('subject_details_screen.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              print('تم حذف: $itemTitle');
              Navigator.pop(context);
            },
            child: Text('subject_details_screen.delete'.tr(), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    // تمت إزالة DefaultTabController واستخدام Scaffold مباشرة
    return Scaffold(
      drawer: CustomDrawer(role: widget.role),
      backgroundColor: scaffoldBackgroundColor,

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
            widget.subjectName,
            style: TextStyle(color: isDarkMode ? Colors.white : primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo')
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController, // 👈 5. ربط المتحكم بشريط التبويبات
          isScrollable: true,
          labelColor: primaryGreen,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryGreen,
          indicatorWeight: 3,
          dividerColor: Colors.transparent,
          tabs: subjectCategories.map((c) => Tab(text: c['title'].toString().tr())).toList(),
        ),
      ),

      body: TabBarView(
        controller: _tabController, // 👈 6. ربط المتحكم بمحتوى التبويبات
        children: subjectCategories.map((category) {
          return _buildFlatCategoryContent(category['id'], category['title'].toString().tr(), category['icon'], isDarkMode, primaryGreen);
        }).toList(),
      ),

      floatingActionButton: widget.role == UserRole.teacher
          ? FloatingActionButton.extended(
        onPressed: () {
          final activeIndex = _tabController.index;

          UploadRestriction currentRestriction;
          if (activeIndex == 0) {
            currentRestriction = UploadRestriction.pdfOnly; // الملازم
          } else if (activeIndex == 1) {
            currentRestriction = UploadRestriction.youtubeLink; // المحاضرات
          } else {
            currentRestriction = UploadRestriction.pdfAndImages; // التكاليف والنماذج
          }

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SmartUploadBottomSheet(
              categoryName: subjectCategories[activeIndex]['title'].toString().tr(),
              restriction: currentRestriction,
            ),
          );
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('subject_details_screen.upload_resource'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null,
    );
  }

  Widget _buildFlatCategoryContent(int categoryId, String categoryName, IconData categoryIcon, bool isDarkMode, Color primaryGreen) {
    final List<Map<String, dynamic>> mockResources = List.generate(
        5,
            (index) => {
          'title': 'subject_details_screen.resource_item_title'.tr(args: [categoryName, (index + 1).toString()]),
          'author': 'subject_details_screen.mock_author'.tr(),
          'icon': categoryIcon,
        }
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: mockResources.length,
      itemBuilder: (context, index) {
        final item = mockResources[index];
        return ResourceItemCard(
          title: item['title'],
          subtitle: item['author'],
          icon: item['icon'],
          role: widget.role,
          onTap: () => print('فتح المورد للقراءة: ${item['title']}'),
          onDownload: () => print('بدء التنزيل: ${item['title']}'),
          onTeacherAction: (action) {
            if (action == 'edit') {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SmartUploadBottomSheet(
                  categoryName: categoryName,
                  restriction: categoryId == 1 ? UploadRestriction.pdfOnly : (categoryId == 2 ? UploadRestriction.youtubeLink : UploadRestriction.pdfAndImages),
                  initialData: {
                    'title': item['title'],
                    'fileName': 'subject_details_screen.previous_file_name'.tr(),
                  },
                ),
              );
            } else if (action == 'delete') {
              _showDeleteConfirmation(item['title']);
            }
          },
        );
      },
    );
  }
}
