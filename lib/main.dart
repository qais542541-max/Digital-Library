import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/settings_provider.dart';
import 'features/login/screens/login_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const Color appPrimaryGreen = Color(0xFF2E7D32);
void main() {
  // 3. تغليف التطبيق بالمتحكم لكي يصل لكل الشاشات
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const DigitalLibraryApp(),
    ),
  );
}

class DigitalLibraryApp extends StatelessWidget {
  const DigitalLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 4. نستدعي المتحكم هنا لقراءة حالة "الوضع المظلم"
    final settings = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'المكتبة الرقمية',
      // ✅ 1. قراءة اللغة الحالية من المتحكم
      locale: Locale(settings.languageCode),

// ✅ 2. اللغات المدعومة في التطبيق
      supportedLocales: const [
        Locale('ar', ''), // العربية
        Locale('en', ''), // الإنجليزية
      ],

// ✅ 3. تفويضات اللغات الخاصة بفلاتر
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 5. السحر يحدث هنا: التبديل التلقائي بين الوضعين الفاتح والمظلم
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // -- إعدادات الوضع الفاتح (التي برمجناها سابقاً) --
      theme: ThemeData(
        brightness: Brightness.light,
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

      // -- إعدادات الوضع المظلم (الجديدة) --
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: appPrimaryGreen),
          backgroundColor: Color(0xFF1E1E1E), // لون رمادي غامق أنيق
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          unselectedLabelColor: Colors.grey,
          labelColor: appPrimaryGreen,
          indicatorColor: appPrimaryGreen,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // لون خلفية التطبيق المظلم
      ),

      home: const LoginScreen(),
    );
  }
}