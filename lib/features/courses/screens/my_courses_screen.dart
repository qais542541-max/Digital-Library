import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../layout/screens/main_screen.dart'; // ملف الـ UserRole
import 'subject_details_screen.dart';

class MyCoursesScreen extends StatelessWidget {
  final UserRole role;

  const MyCoursesScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final selectedYear = settings.academicYear;
    final isDarkMode = settings.isDarkMode;
    final isArabic = settings.languageCode == 'ar';
    const Color primaryGreen = Color(0xFF2E7D32);

    final List<String> years = ['السنة الأولى', 'السنة الثانية', 'السنة الثالثة', 'السنة الرابعة'];

    final String yearLabel = role == UserRole.student
        ? (isArabic ? 'المستوى الدراسي:' : 'Academic Year:')
        : (isArabic ? 'سنة التدريس:' : 'Teaching Year:');

    final List<Map<String, dynamic>> term1Courses = [
      {'id': 1, 'title': 'إدارة المشاريع البرمجية ($selectedYear)', 'doctor': 'م. خالد', 'icon': Icons.computer},
    ];
    final List<Map<String, dynamic>> term2Courses = [
      {'id': 4, 'title': 'برمجة تطبيقات الهاتف', 'doctor': 'د. علي', 'icon': Icons.phone_android},
    ];

    return DefaultTabController(
      length: 2,
      initialIndex: settings.academicTermIndex,
      child: SafeArea(
        child: Column(
          children: [
            // 1. الترويسة المخصصة (أيقونات + قائمة منسدلة مصغرة)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),

                  // 👇 قائمة السنة / المستوى (تم تصغيرها) 👇
                  Row(
                    children: [
                      Text(
                        yearLabel,
                        style: TextStyle(
                          fontSize: 12, // 👈 تصغير الخط
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 6), // 👈 تقليل المسافة
                      Container(
                        height: 32, // 👈 تحديد ارتفاع صغير للقائمة
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(8), // حواف أقل دائرية لتناسب الحجم الصغير
                          border: Border.all(color: primaryGreen.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedYear,
                            dropdownColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                            icon: const Icon(Icons.keyboard_arrow_down, color: primaryGreen, size: 18), // 👈 تصغير الأيقونة
                            style: TextStyle(
                              fontSize: 12, // 👈 تصغير الخط الداخلي
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                            items: years.map((String year) => DropdownMenuItem<String>(value: year, child: Text(year))).toList(),
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

            // 👇 2. شريط البحث المتقدم المنفصل والمصغر (Shamela Style) 👇
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Row(
                children: [
                  // زر البحث المتقدم (منفصل)
                  Container(
                    height: 45, // نفس ارتفاع شريط البحث
                    width: 45,
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: primaryGreen, size: 20),
                      onPressed: () {
                        // TODO: إظهار نافذة البحث المتقدم
                      },
                    ),
                  ),
                  const SizedBox(width: 10), // مسافة بين الزر وشريط البحث

                  // شريط البحث الأساسي
                  Expanded(
                    child: Container(
                      height: 45, // 👈 تحديد ارتفاع نحيف للشريط
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                      ),
                      child: TextField(
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: isArabic ? 'ابحث عن مقرر...' : 'Search for course...',
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                          prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20), // 👈 أيقونة أصغر
                          border: InputBorder.none,
                          isDense: true, // 👈 يجعل الحقل مدمجاً أكثر
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 👇 3. شريط التبويبات المدمج (بدون خط سفلي) 👇
            Container(
              color: Colors.transparent,
              child: TabBar(
                dividerColor: Colors.transparent, // 👈 إزالة الخط الرمادي من هنا
                labelColor: primaryGreen,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryGreen,
                tabs: [
                  Tab(text: isArabic ? 'الترم الأول' : 'First Term'),
                  Tab(text: isArabic ? 'الترم الثاني' : 'Second Term'),
                ],
              ),
            ),

            // 4. عرض محتوى التبويبات
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