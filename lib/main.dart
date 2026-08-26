import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 ضروري جداً للتحكم بشريط النظام
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/providers/settings_provider.dart';
import 'features/login/screens/login_screen.dart';

const Color appPrimaryGreen = Color(0xFF2E7D32);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // 👇 السحر الذي اختفى: جعل شريط النظام (أزرار الرجوع والهوم) شفافاً
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,

      // 👇 هذا هو السطر السري الذي يوقف تدخل أندرويد 10 الإجباري!
      systemNavigationBarContrastEnforced: false,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,

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