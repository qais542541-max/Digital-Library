import 'package:flutter/material.dart';
import '../../layout/screens/main_screen.dart'; // لاستدعاء UserRole
import '../../../core/widgets/resource_item_card.dart'; // 👈 استدعاء الكارد الجديد

class DownloadsScreen extends StatefulWidget {
  final UserRole role; // 👈 إضافة الدور لتمريره للبطاقة

  const DownloadsScreen({super.key, required this.role});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List<Map<String, dynamic>> downloadedItems = [
    {
      'id': '1',
      'title': 'كتاب البرمجة بلغة C++',
      'subtitle': 'ملف PDF - 2.5 MB',
      'icon': Icons.picture_as_pdf,
    },
    {
      'id': '2',
      'title': 'مذكرة قواعد البيانات',
      'subtitle': 'مستند - 1.2 MB',
      'icon': Icons.book,
    },
  ];

  void _removeItem(int index) {
    final removedItem = downloadedItems[index];

    setState(() {
      downloadedItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف: ${removedItem['title']}'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.blueAccent,
          onPressed: () {
            setState(() {
              downloadedItems.insert(index, removedItem);
            });
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // 👈 توحيد الخلفية
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        leading: const SizedBox(), // تفريغ اليمين
        title: Text(
          'تحميلاتي',
          style: TextStyle(color: isDarkMode ? Colors.white : primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        ),
        centerTitle: true,
        actions: [
          // 👈 زر الرجوع في اليسار
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white : primaryGreen, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: downloadedItems.isEmpty
          ? const Center(
        child: Text(
          'لا توجد ملفات محملة حالياً',
          style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Cairo'),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: downloadedItems.length,
        itemBuilder: (context, index) {
          final item = downloadedItems[index];

          return Dismissible(
            key: Key(item['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              color: Colors.red,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // 👈 مطابقة هوامش البطاقة
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              // 👈 نافذة الحذف الموحدة
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("تأكيد الحذف", style: TextStyle(fontFamily: 'Cairo')),
                    content: const Text("هل أنت متأكد من حذف هذا الملف نهائياً من جهازك؟"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("حذف", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              _removeItem(index);
            },
            child: ResourceItemCard( // 👈 استخدام البطاقة الجديدة
              title: item['title'],
              subtitle: item['subtitle'],
              icon: item['icon'],
              role: widget.role,
              onTap: () => print('فتح ${item['title']}'),
              onDownload: () => print('الملف محمل مسبقاً'),
            ),
          );
        },
      ),
    );
  }
}