import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/constants/api_constants.dart'; // 👈 استدعاء ملف الروابط المركزي
import '../../../core/widgets/resource_item_card.dart';
import 'package:digital_library/features/layout/screens/main_screen.dart';
import 'package:digital_library/features/library/screens/pdf_viewer_screen.dart';

class BooksListScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int subjectId;
  final UserRole role;
  final bool isPublicLibrary; // true للمكتبة الرقمية، false للمكتبة الورقية

  const BooksListScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
    required this.subjectId,
    required this.role,
    required this.isPublicLibrary,
  });

  @override
  State<BooksListScreen> createState() => _BooksListScreenState();
}

class _BooksListScreenState extends State<BooksListScreen> {
  late Future<List<Map<String, dynamic>>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _fetchBooks();
  }

  // جلب الكتب من الـ API بناءً على نوع المكتبة ورقم القسم
  Future<List<Map<String, dynamic>>> _fetchBooks() async {
    String type = widget.isPublicLibrary ? 'digital' : 'physical';
    String url = '${ApiConstants.getBooks}?id=${widget.categoryId}&type=$type';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب الكتب: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // الترويسة العلوية الموحدة مع زر الرجوع
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
              child: SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.categoryName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // محتوى القائمة مع FutureBuilder
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _booksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: primaryGreen));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'حدث خطأ أثناء تحميل البيانات',
                        style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade600),
                      ),
                    );
                  }

                  final books = snapshot.data ?? [];

                  if (books.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.library_books_outlined, size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            'لا توجد عناصر متاحة في هذا القسم حالياً',
                            style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final item = books[index];
                      // إذا كانت مكتبة ورقية، نعرض موقع الرف، وإذا كانت رقمية نعرض اسم المؤلف
                      final subtitleText = widget.isPublicLibrary
                          ? 'المؤلف: ${item['author']}'
                          : 'موقع الرف: ${item['shelf_location']} (المؤلف: ${item['author']})';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ResourceItemCard(
                          title: item['title'] ?? 'بدون عنوان',
                          subtitle: subtitleText,
                          icon: widget.isPublicLibrary ? Icons.picture_as_pdf : Icons.book,
                          role: widget.role,
                          onTap: () {
                            if (widget.isPublicLibrary) {
                              // التحقق من وجود مسار ملف للكتاب
                              if (item['file_path'] != null && item['file_path'].toString().isNotEmpty) {
                                // دمج الرابط الأساسي مع مسار الملف
                                String fullUrl = '${ApiConstants.baseFileUrl}${item['file_path']}';

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfViewerScreen(
                                      pdfUrl: fullUrl,
                                      bookTitle: item['title'] ?? 'بدون عنوان',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('عذراً، ملف الكتاب غير متاح حالياً', style: TextStyle(fontFamily: 'Cairo')),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            } else {
                              // هنا يمكن لاحقاً إظهار نافذة منبثقة تفيد بموقع الكتاب الورقي
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('الكتاب موجود في ${item['shelf_location']}', style: const TextStyle(fontFamily: 'Cairo')),
                                  backgroundColor: Color(0xFF2E7D32),
                                ),
                              );
                            }
                          },
                          // إلغاء زر التنزيل إذا كانت المكتبة ورقية بحتة ليس لها ملف
                          onDownload: widget.isPublicLibrary && item['file_path'] != null
                              ? () => print('بدء تنزيل الملف: ${item['title']}')
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}