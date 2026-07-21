//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// تأكد أن هذا المسار يطابق اسم مشروعك الفعلي
import 'package:digital_library/main.dart';

void main() {
  testWidgets('Digital Library App smoke test', (WidgetTester tester) async {
    // بناء تطبيق المكتبة الرقمية الخاص بنا
    await tester.pumpWidget(const DigitalLibraryApp());

    // التأكد من ظهور عنوان التطبيق في الشاشة الرئيسية
    expect(find.text('المكتبة الرقمية'), findsWidgets);
  });
}