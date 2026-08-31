import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost/lib_book2/api/';
    return 'http://192.168.1.100/lib_book2/api/';
  }

  // 👇 الرابط الأساسي للملفات والصور (بدون مجلد api)
  static String get baseFileUrl {
    if (kIsWeb) return 'http://localhost/lib_book2/';
    return 'http://192.168.1.100/lib_book2/';
  }

  static String get login => '${baseUrl}login.php';
  static String get getLibrarySections => '${baseUrl}get_library_sections.php';
  //رابط جلب الكتب
  static String get getBooks => '${baseUrl}get_books.php';
  // 👇 المسار الجديد الخاص بالمقررات
  static String get getSubjects => '${baseUrl}get_subjects.php';
  //المسار الخاص بفتح الملفات بدون نت وفي مكانها الهيكلي الاكاديمي في المقرر
  static String get getSubjectDetails => '${baseUrl}get_subject_details.php';
}