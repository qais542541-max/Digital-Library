import 'package:flutter/material.dart';

// استدعاء الكارد الموحد
import '../../../core/widgets/unified_item_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // بيانات مؤقتة لتشغيل الشاشة
  List<Map<String, dynamic>> favoriteItems = [
    {
      'id': 1,
      'title': 'كتاب البرمجة بلغة C++',
      'subtitle': 'أساسيات البرمجة',
      'icon': Icons.picture_as_pdf,
    },
    {
      'id': 2,
      'title': 'مذكرة قواعد البيانات',
      'subtitle': 'مستوى متقدم',
      'icon': Icons.book,
    },
  ];

  // دالة الحذف وتحديث الواجهة
  void _removeItem(int index, String actionType) {
    final removedItem = favoriteItems[index];

    setState(() {
      favoriteItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    // إظهار رسالة حسب نوع الحذف
    String message = actionType == 'favorite_only'
        ? 'تمت الإزالة من التفضيلات: ${removedItem['title']}'
        : 'تمت الإزالة والحذف من الجهاز: ${removedItem['title']}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مفضلاتي'),
        centerTitle: true,
      ),
      body: favoriteItems.isEmpty
          ? const Center(
        child: Text(
          'لا توجد عناصر في المفضلة حالياً',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];

          return Dismissible(
            // تم إضافة toString() لأن الـ Key يقبل نصوص فقط
            key: Key(item['id'].toString()),
            direction: DismissDirection.endToStart,

            // تصميم الخلفية عند السحب (اللون الأحمر مع أيقونة سلة المهملات)
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            // نافذة التأكيد المنبثقة بثلاثة خيارات
            confirmDismiss: (direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("إزالة من التفضيلات"),
                    content: const Text("ما الإجراء الذي تريد اتخاذه تجاه هذا المورد؟"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null), // إلغاء السحب
                        child: const Text("إلغاء"),
                      ),
                      TextButton(
                        onPressed: () {
                          // إرجاع قيمة تدل على نوع الحذف
                          Navigator.of(context).pop('favorite_only');
                        },
                        child: const Text("إزالة من التفضيلات فقط"),
                      ),
                      TextButton(
                        onPressed: () {
                          // إرجاع قيمة تدل على الحذف الكلي
                          Navigator.of(context).pop('delete_both');
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

            // تنفيذ الحذف بناءً على الخيار الذي تم اختياره في النافذة المنبثقة
            onDismissed: (direction) {
              // ملاحظة: الـ direction هنا يعطينا اتجاه السحب، لكننا نعتمد على ما أرجعناه من confirmDismiss
              // بما أن onDismissed لا تستقبل النتيجة المرجعة من confirmDismiss مباشرة،
              // سنقوم بتمرير نوع افتراضي مؤقتاً، وسنحتاج مستقبلاً لمعالجة الحذف الفعلي (Delete from device)
              // إما داخل confirmDismiss نفسها قبل الـ pop، أو عبر متغيرات مساعدة.

              // للتطبيق الحالي (تحديث الواجهة):
              _removeItem(index, 'favorite_only');
            },
            child: UnifiedItemCard(
              title: item['title'],
              subtitle: item['subtitle'],
              isGridView: false,
              icon: item['icon'],
            ),
          );
        },
      ),
    );
  }
}