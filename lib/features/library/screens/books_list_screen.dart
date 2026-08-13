import 'package:flutter/material.dart';
import 'pdf_viewer_screen.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../layout/screens/main_screen.dart'; // 👈 1. استدعاء ملف الـ enum

class BooksListScreen extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int subjectId;
  final UserRole role; // 👈 2. استقبال الدور

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

    return Scaffold(
      drawer: CustomDrawer(role: widget.role),
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)),
        title: Text(widget.categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        // ... نفس محتوى الـ Column السابق (البحث والقوائم) يوضع هنا بدون تغيير[cite: 5]
      ),

      // 👈 3. الشرط الذكي: الزر يظهر فقط للمعلم والموظف الإداري
      floatingActionButton: (widget.role == UserRole.teacher || widget.role == UserRole.employee)
          ? FloatingActionButton.extended(
        onPressed: () {
          // النظام هنا يعرف مسبقاً أننا في القسم (widget.categoryId)
          print('فتح واجهة رفع ملف للقسم: ${widget.categoryName}');
        },
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.cloud_upload, color: Colors.white),
        label: const Text('رفع مرجع هنا', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      )
          : null, // لا يظهر شيء لبقية المستخدمين
    );
  }
}