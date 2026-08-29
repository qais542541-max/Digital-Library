import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../layout/screens/main_screen.dart';
import 'subject_details_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  final UserRole role;

  const MyCoursesScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final isArabic = context.locale.languageCode == 'ar';
    const Color primaryGreen = Color(0xFF2E7D32);

    final List<String> yearKeys = [
      'my_courses_screen.first_year',
      'my_courses_screen.second_year',
      'my_courses_screen.third_year',
      'my_courses_screen.fourth_year'
    ];

    // 👇 1. جلب القيمة من الذاكرة
    String rawSavedYear = settings.academicYear;
    String currentYearValue;

    // 👇 2. خوارزمية تنظيف الذاكرة (معالجة النصوص القديمة بقوة)
    if (yearKeys.contains(rawSavedYear)) {
      currentYearValue = rawSavedYear; // إذا كانت مفتاحاً صحيحاً، استخدمها
    } else {
      // إذا كانت نصاً عربياً قديماً، نقوم بترجمتها للمفتاح الجديد فوراً
      switch (rawSavedYear) {
        case 'السنة الأولى': currentYearValue = yearKeys[0]; break;
        case 'السنة الثانية': currentYearValue = yearKeys[1]; break;
        case 'السنة الثالثة': currentYearValue = yearKeys[2]; break;
        case 'السنة الرابعة': currentYearValue = yearKeys[3]; break;
        default: currentYearValue = yearKeys[2]; // الافتراضي: السنة الثالثة
      }
      // حفظ المفتاح الجديد الصحيح في الذاكرة بهدوء
      Future.microtask(() => settings.changeAcademicYear(currentYearValue));
    }

    final String yearLabel = role == UserRole.student
        ? 'my_courses_screen.academic_year_label'.tr()
        : 'my_courses_screen.teaching_year_label'.tr();

    final List<Map<String, dynamic>> term1Courses = [
      {
        'id': 1,
        // 👇 3. قمنا بإضافة .tr() للمتغير لكي يظهر للمستخدم مترجماً بشكل صحيح داخل النص
        'title': 'my_courses_screen.software_project_management'.tr(args: [currentYearValue.tr()]),
        'doctor': 'my_courses_screen.eng_khaled'.tr(),
        'icon': Icons.computer
      },
    ];
    final List<Map<String, dynamic>> term2Courses = [
      {
        'id': 4,
        'title': 'my_courses_screen.mobile_programming'.tr(),
        'doctor': 'my_courses_screen.dr_ali'.tr(),
        'icon': Icons.phone_android
      },
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: settings.academicTermIndex,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Row(
                    children: [
                      Text(
                        yearLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryGreen.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: currentYearValue, // 👈 استخدام المتغير المحمي (المفتاح الثابت)
                            dropdownColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                            icon: const Icon(Icons.keyboard_arrow_down, color: primaryGreen, size: 18),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                            // 👇 4. هنا السحر: القيمة المخزنة هي المفتاح (key) ولكن النص المعروض مترجم (key.tr())
                            items: yearKeys.map((String key) => DropdownMenuItem<String>(
                              value: key,
                              child: Text(key.tr()),
                            )).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) settings.changeAcademicYear(newValue);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                ),
                child: TextField(
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14, fontFamily: 'Cairo'),
                  decoration: InputDecoration(
                    hintText: 'my_courses_screen.search_hint'.tr(),
                    hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontFamily: 'Cairo'),
                    prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.transparent,
              child: TabBar(
                dividerColor: Colors.transparent,
                labelColor: primaryGreen,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryGreen,
                tabs: [
                  Tab(text: 'my_courses_screen.first_term'.tr()),
                  Tab(text: 'my_courses_screen.second_term'.tr()),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCoursesList(term1Courses, context),
                  _buildCoursesList(term2Courses, context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesList(List<Map<String, dynamic>> courses, BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20, left: 16, right: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final subject = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: UnifiedItemCard(
            title: subject['title'],
            subtitle: subject['doctor'],
            icon: subject['icon'],
            isGridView: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectDetailsScreen(
                    subjectName: subject['title'],
                    subjectId: subject['id'],
                    role: role,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}