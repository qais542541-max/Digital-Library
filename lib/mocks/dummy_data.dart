import 'package:flutter/material.dart'; // 👈 هذا هو السطر الذي سيخفي الخطأ عن الأيقونات
import '../models/subject_model.dart';
import '../models/resource_model.dart';

// قائمة المقررات الوهمية
final List<Subject> dummySubjects = [
  Subject(id: 1, title: 'برمجة تطبيقات الهاتف', icon: Icons.phone_android),
  Subject(id: 2, title: 'قواعد البيانات', icon: Icons.storage),
  Subject(id: 3, title: 'هندسة البرمجيات', icon: Icons.computer),
];

// قائمة الموارد الوهمية (بدون أيقونات)
final List<Resource> dummyResources = [
  // موارد مادة برمجة تطبيقات الهاتف (رقم المادة: 1)
  Resource(id: 1, subjectId: 1, title: 'مقدمة في Flutter', type: 'book', size: '2.5 MB'),
  Resource(id: 2, subjectId: 1, title: 'شرح الواجهات (UI)', type: 'lecture', size: '1.2 MB'),

  // موارد مادة قواعد البيانات (رقم المادة: 2)
  Resource(id: 3, subjectId: 2, title: 'تصميم ERD', type: 'book', size: '3.0 MB'),
  Resource(id: 4, subjectId: 2, title: 'استعلامات SQL', type: 'summary', size: '1.0 MB'),
];