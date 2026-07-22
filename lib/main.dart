import 'package:flutter/material.dart';
import 'features/student/screens/main_student_screen.dart'; // تأكد من مسار الملف

void main() {
  runApp(const DigitalLibraryApp());
}

class DigitalLibraryApp extends StatelessWidget {
  const DigitalLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المكتبة الرقمية',
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl, // توجيه التطبيق للغة العربية
          child: child!,
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainStudentScreen(), // نقطة الانطلاق
    );
  }
}