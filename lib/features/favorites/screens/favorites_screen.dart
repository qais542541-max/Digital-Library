import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../layout/screens/main_screen.dart';
import '../../../core/widgets/resource_item_card.dart';

class FavoritesScreen extends StatefulWidget {
  final UserRole role;

  const FavoritesScreen({super.key, required this.role});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteItems = [
    {
      'id': '1',
      'title': 'favorites_screen.java_book_title'.tr(),
      'subtitle': 'favorites_screen.java_book_subtitle'.tr(),
      'icon': Icons.picture_as_pdf,
    },
    {
      'id': '2',
      'title': 'favorites_screen.algorithms_lecture_title'.tr(),
      'subtitle': 'favorites_screen.algorithms_lecture_subtitle'.tr(),
      'icon': Icons.ondemand_video,
    },
  ];

  void _removeItem(int index, String actionType) {
    final removedItem = favoriteItems[index];

    setState(() {
      favoriteItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    String message = actionType == 'favorite_only'
        ? 'favorites_screen.removed_from_favorites'.tr(args: [removedItem['title']])
        : 'favorites_screen.removed_and_deleted'.tr(args: [removedItem['title']]);

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);
    final Color scaffoldBackgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor, // 👈 توحيد الخلفية
      appBar: AppBar(
        elevation: 0,
        backgroundColor: scaffoldBackgroundColor,
        leading: const SizedBox(),
        title: Text(
          'favorites_screen.title'.tr(),
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
      body: favoriteItems.isEmpty
          ? Center(
        child: Text(
          'favorites_screen.no_items'.tr(),
          style: const TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Cairo'),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final item = favoriteItems[index];

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
              // 👈 نافذة الحذف الموحدة بتصميم يتطابق مع البقية
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("favorites_screen.remove_dialog_title".tr(), style: const TextStyle(fontFamily: 'Cairo')),
                    content: Text("favorites_screen.remove_dialog_content".tr()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: Text("favorites_screen.cancel".tr(), style: const TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop('favorite_only'),
                        child: Text("favorites_screen.remove_only".tr(), style: const TextStyle(color: primaryGreen)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () => Navigator.of(context).pop('delete_both'),
                        child: Text("favorites_screen.remove_and_delete".tr(), style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              // الاعتماد مؤقتاً على الإزالة من التفضيلات، ويمكنك برمجتها لاحقاً لتمرير الخيار الفعلي
              _removeItem(index, 'favorite_only');
            },
            child: ResourceItemCard( // 👈 استخدام البطاقة الجديدة
              title: item['title'],
              subtitle: item['subtitle'],
              icon: item['icon'],
              role: widget.role,
              onTap: () => print('فتح ${item['title']}'),
              onDownload: () => print('بدء تحميل ${item['title']}'),
            ),
          );
        },
      ),
    );
  }
}
