import 'package:flutter/material.dart';

// استدعاء الكارد الموحد فقط (تمت إزالة الاستيرادات التي تسبب الأخطاء)
import '../../../core/widgets/unified_item_card.dart';

class DownloadsScreen extends StatefulWidget {
  // تم حل ملاحظة (super parameter) هنا
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  // استخدام بيانات مؤقتة (Map) لحل مشكلة ResourceModel وتشغيل الشاشة فوراً
  List<Map<String, dynamic>> downloadedItems = [
    {
      'id': 1,
      'title': 'عنوان الملف الأول',
      'subtitle': 'وصف أو تصنيف الملف الأول',
      'icon': Icons.picture_as_pdf,
    },
    {
      'id': 2,
      'title': 'عنوان الملف الثاني',
      'subtitle': 'وصف أو تصنيف الملف الثاني',
      'icon': Icons.book,
    },
  ];

  // دالة التعامل مع الحذف وإظهار خيار التراجع
  void _removeItem(int index) {
    final removedItem = downloadedItems[index];

    // 1. إزالة العنصر من الواجهة
    setState(() {
      downloadedItems.removeAt(index);
    });

    // 2. إخفاء أي رسائل سابقة
    ScaffoldMessenger.of(context).clearSnackBars();

    // 3. إظهار رسالة (SnackBar) مع زر التراجع
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حذف: ${removedItem['title']}'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.blueAccent,
          onPressed: () {
            // 4. إعادة العنصر لنفس مكانه عند الضغط على تراجع
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحميلاتي'),
        centerTitle: true,
      ),
      body: downloadedItems.isEmpty
          ? const Center(
        child: Text(
          'لا توجد ملفات محملة حالياً',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: downloadedItems.length,
        itemBuilder: (context, index) {
          final item = downloadedItems[index];

          return Dismissible(
            key: Key(item['id']), // تأكد من استخدام مفتاح فريد
            direction: DismissDirection.endToStart,
            // ... (إعدادات الخلفية الحمراء background تبقى كما هي) ...

            // إضافة هذه الخاصية لاعتراض السحب
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("إزالة من التفضيلات"),
                      content: const Text("ما الإجراء الذي تريد اتخاذه تجاه هذا الكتاب؟"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("إلغاء"),
                        ),
                        TextButton(
                          onPressed: () {
                            // مسح من التفضيلات فقط
                            // Navigator.of(context).pop(true);
                          },
                          child: const Text("إزالة من التفضيلات فقط"),
                        ),
                        TextButton(
                          onPressed: () {
                            // مسح من التفضيلات + حذف الملف من الهاتف
                            // Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "إزالة وحذف من الهاتف",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            onDismissed: (direction) {
              // الكود الخاص بحذف العنصر من القائمة (setState) يوضع هنا
            },
            child: UnifiedItemCard( /* ... */
              // تم حل مشكلة البارامترات المطلوبة (Required) بتمريرها هنا
              title: item['title'],
              subtitle: item['subtitle'],
              isGridView: false, // القيمة false لأننا نستخدم ListView
              icon: item['icon'],),
          );
        },
      ),
    );
  }
}