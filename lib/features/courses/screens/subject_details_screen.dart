import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../layout/screens/main_screen.dart';
import '../../../core/widgets/resource_item_card.dart';
import '../../../core/widgets/smart_upload_bottom_sheet.dart';
import '../../../core/constants/api_constants.dart';
import 'package:digital_library/features/library/screens/pdf_viewer_screen.dart';
import '../../../core/helpers/file_manager.dart';

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
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // 👇 1. إضافة متغير الـ Future الخاص بالـ API
  late Future<Map<String, List<Map<String, dynamic>>>> _detailsFuture;

  final List<Map<String, dynamic>> subjectCategories = [
    {'id': 1, 'title': 'subject_details_screen.handouts', 'icon': Icons.menu_book},
    {'id': 2, 'title': 'subject_details_screen.lectures', 'icon': Icons.ondemand_video},
    {'id': 4, 'title': 'subject_details_screen.forms', 'icon': Icons.quiz},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: subjectCategories.length, vsync: this);
    // 👇 2. استدعاء الدالة عند فتح الشاشة
    _detailsFuture = _fetchSubjectDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // 👇 3. دالة جلب البيانات من الـ API
  Future<Map<String, List<Map<String, dynamic>>>> _fetchSubjectDetails() async {
    String url = '${ApiConstants.getSubjectDetails}?subject_id=${widget.subjectId}';
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'handouts': List<Map<String, dynamic>>.from(data['handouts'] ?? []),
            'lectures': List<Map<String, dynamic>>.from(data['lectures'] ?? []),
            'exam_models': List<Map<String, dynamic>>.from(data['exam_models'] ?? []),
          };
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب تفاصيل المقرر: $e');
    }
    return {'handouts': [], 'lectures': [], 'exam_models': []};
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
          controller: _tabController,
          isScrollable: true,
          labelColor: primaryGreen,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryGreen,
          indicatorWeight: 3,
          dividerColor: Colors.transparent,
          tabs: subjectCategories.map((c) => Tab(text: c['title'].toString().tr())).toList(),
        ),
      ),

      // 👇 4. تغليف TabBarView بـ FutureBuilder لجلب البيانات الحية
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: primaryGreen));
          }
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ في جلب البيانات', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade600)));
          }

          final allData = snapshot.data ?? {'handouts': [], 'lectures': [], 'exam_models': []};

          return TabBarView(
            controller: _tabController,
            children: subjectCategories.map((category) {
              // توزيع البيانات المستلمة بناءً على نوع التبويب
              String dataKey = '';
              if (category['id'] == 1) dataKey = 'handouts';
              else if (category['id'] == 2) dataKey = 'lectures';
              else if (category['id'] == 4) dataKey = 'exam_models';

              List<Map<String, dynamic>> categoryItems = allData[dataKey] ?? [];

              return _buildFlatCategoryContent(category['id'], category['title'].toString().tr(), category['icon'], isDarkMode, primaryGreen, categoryItems);
            }).toList(),
          );
        },
      ),

      floatingActionButton: widget.role == UserRole.teacher
          ? FloatingActionButton.extended(
        onPressed: () {
          final activeIndex = _tabController.index;

          UploadRestriction currentRestriction;
          if (activeIndex == 1) {
            currentRestriction = UploadRestriction.mixedContent;
          } else {
            currentRestriction = UploadRestriction.pdfAndImages;
          }

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SmartUploadBottomSheet(
              categoryName: subjectCategories[activeIndex]['title'].toString().tr(),
              restriction: currentRestriction,
              isCourseMaterial: true,
            ),
          );
        },
        backgroundColor: primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('subject_details_screen.upload_resource'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      )
          : null,
    );
  }

  // 👇 5. تم تعديل هذه الدالة لتستقبل items بدلاً من بناء بيانات وهمية
  Widget _buildFlatCategoryContent(int categoryId, String categoryName, IconData categoryIcon, bool isDarkMode, Color primaryGreen, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(categoryIcon, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text('لا توجد ملفات في هذا القسم حالياً', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isPractical = item['is_practical'] == true;
        final filePath = item['file_path'];

        final String fileName = FileManager.getFileNameFromPath(filePath ?? '');
        final String fullUrl = filePath != null ? '${ApiConstants.baseFileUrl}$filePath' : '';

        // 👇 1. غلفنا البطاقة بـ FutureBuilder ليفحص وجود الملف في الهاتف قبل رسمه
        return FutureBuilder<bool>(
            future: isPractical ? Future.value(false) : FileManager.isFileDownloaded(fileName),
            builder: (context, snapshot) {
              // إذا كان الملف محملاً مسبقاً ستكون النتيجة true
              bool isDownloaded = snapshot.data ?? false;

              return ResourceItemCard(
                title: item['title'] ?? 'بدون عنوان',
                subtitle: item['author'] ?? 'غير محدد',
                icon: categoryId == 2 && isPractical ? Icons.ondemand_video_rounded : categoryIcon,
                role: widget.role,
                isPractical: isPractical,

                onTap: () async {
                  if (isPractical) {
                    print('تشغيل / فتح المورد العملي: ${item['title']}');
                  } else {
                    if (filePath != null && filePath.toString().isNotEmpty) {
                      // التحقق عند الفتح
                      bool downloaded = await FileManager.isFileDownloaded(fileName);
                      if (downloaded) {
                        String localPath = await FileManager.getLocalFilePath(fileName);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => PdfViewerScreen(pdfUrl: localPath, bookTitle: item['title'], isLocal: true)
                        ));
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (_) => PdfViewerScreen(pdfUrl: fullUrl, bookTitle: item['title'], isLocal: false)
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الملف غير متاح حالياً', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.orange));
                    }
                  }
                },

                actionIcon: isPractical ? Icons.play_arrow_rounded : Icons.file_download_outlined,

                // 👇 2. السحر هنا: إذا كان الملف محملاً، نمرر null، فيختفي الزر تلقائياً حسب تصميمك
                onDownload: (isPractical || isDownloaded) ? null : () async {
                  if (filePath != null && filePath.toString().isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('جاري تنزيل ${item['title']}...', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: primaryGreen));

                    String? savedPath = await FileManager.downloadFile(
                        url: fullUrl,
                        fileName: fileName,
                        onProgress: (received, total) {}
                    );

                    if (savedPath != null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم التنزيل بنجاح!', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: primaryGreen));

                      // 👇 3. تحديث الشاشة فوراً لإخفاء الزر بعد انتهاء التنزيل
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء التنزيل.', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.red));
                    }
                  }
                },

                onTeacherAction: (action) {
                  if (action == 'delete') {
                    _showDeleteConfirmation(item['title']);
                  }
                },
              );
            }
        );
      },
    );
  }
}