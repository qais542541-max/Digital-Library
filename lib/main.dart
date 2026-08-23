import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 1. استدعاء مكتبة الترجمة
import 'core/providers/settings_provider.dart';
import 'features/login/screens/login_screen.dart';

const Color appPrimaryGreen = Color(0xFF2E7D32);

void main() async {
  // 👇 2. سطور تهيئة الترجمة قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 👇 3. التغليف المزدوج: EasyLocalization يحيط بـ Provider
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations', // مسار مجلد الترجمة الذي أنشأناه
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'), // يمكنك لاحقاً ربطها بالـ SharedPreferences
      child: ChangeNotifierProvider(
        create: (context) => SettingsProvider(),
        child: const DigitalLibraryApp(),
      ),
    ),
  );
}

class DigitalLibraryApp extends StatelessWidget {
  const DigitalLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المكتبة الرقمية',

      // 👇 4. قراءة تفويضات ولغة التطبيق من easy_localization بدلاً من إدخالها يدوياً
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // 5. التبديل التلقائي بين الوضعين الفاتح والمظلم بناءً على الـ Provider
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // -- إعدادات الوضع الفاتح --
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey.shade50,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: appPrimaryGreen),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          unselectedLabelColor: Colors.grey,
          labelColor: appPrimaryGreen,
          indicatorColor: appPrimaryGreen,
        ),
      ),

      // -- إعدادات الوضع المظلم --
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: appPrimaryGreen),
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          unselectedLabelColor: Colors.grey,
          labelColor: appPrimaryGreen,
          indicatorColor: appPrimaryGreen,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}