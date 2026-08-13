import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// الكلاس يرث من ChangeNotifier لكي يمتلك قدرة "تنبيه التطبيق" بالتغييرات
class SettingsProvider extends ChangeNotifier {

  // 1. المتغيرات الخاصة بنا (تبدأ بـ _ لتكون محمية داخل هذا الملف فقط)
  bool _isDarkMode = false;
  bool _generalNotifications = true;
  bool _physicalBookAlerts = true;
  String _languageCode = 'ar'; // اللغة الافتراضية هي العربية
  String get languageCode => _languageCode;

  // 2. توفير طريقة للواجهات (الشاشات) لقراءة هذه القيم
  bool get isDarkMode => _isDarkMode;
  bool get generalNotifications => _generalNotifications;
  bool get physicalBookAlerts => _physicalBookAlerts;

  String _academicYear = 'السنة الثالثة'; // القيمة الافتراضية
  int _academicTermIndex = 0; // 0 للترم الأول، 1 للترم الثاني

  String get academicYear => _academicYear;
  int get academicTermIndex => _academicTermIndex;

  // 3. هذه الدالة تعمل تلقائياً بمجرد تشغيل التطبيق لجلب البيانات المحفوظة
  SettingsProvider() {
    _loadSettings();
  }

  // دالة قراءة البيانات من ذاكرة الهاتف
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _languageCode = prefs.getString('languageCode') ?? 'ar';

    // إذا لم يجد قيمة سابقة، سيعتبر الوضع المظلم false (فاتح)
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _generalNotifications = prefs.getBool('generalNotifications') ?? true;
    _physicalBookAlerts = prefs.getBool('physicalBookAlerts') ?? true;

//جلب بيانات السنة والترم
    _academicYear = prefs.getString('academicYear') ?? 'السنة الثالثة';
    _academicTermIndex = prefs.getInt('academicTermIndex') ?? 0;

    notifyListeners(); // تحديث الواجهات بناءً على ما تم جلبه من الذاكرة
  }

  // 4. دوال التعديل (التي سنستدعيها عند الضغط على الأزرار في شاشة الإعدادات)

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value); // حفظ القيمة الجديدة في الذاكرة
    notifyListeners(); // 👈 هذا هو "السحر" الذي يغير لون التطبيق فوراً
  }

  Future<void> toggleGeneralNotifications(bool value) async {
    _generalNotifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('generalNotifications', value);
    notifyListeners();
  }

  Future<void> togglePhysicalBookAlerts(bool value) async {
    _physicalBookAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('physicalBookAlerts', value);
    notifyListeners();
  }
  Future<void> changeLanguage(String code) async {
    if (_languageCode == code) return; // إذا اختار نفس اللغة لا تفعل شيئاً
    _languageCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    notifyListeners(); // تنبيه التطبيق بالكامل لتغيير الاتجاه
  }
//دالتين حفظ وضع السنة والترم
  Future<void> changeAcademicYear(String year) async {
    if (_academicYear == year) return;
    _academicYear = year;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('academicYear', year);
    notifyListeners();
  }

  Future<void> changeAcademicTerm(int index) async {
    if (_academicTermIndex == index) return;
    _academicTermIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('academicTermIndex', index);
    notifyListeners();
  }
}