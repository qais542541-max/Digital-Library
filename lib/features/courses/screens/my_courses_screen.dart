import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import 'package:digital_library/features/layout/screens/main_screen.dart';
import 'package:digital_library/features/courses/screens/subject_details_screen.dart';
import '../../login/screens/login_screen.dart';

class MyCoursesScreen extends StatefulWidget {
  final UserRole role;

  const MyCoursesScreen({super.key, required this.role});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<Map<String, List<Map<String, dynamic>>>> _coursesFuture;
  late SettingsProvider _settings;

  // قائمة السنوات كمفاتيح رقمية لسهولة إرسالها للـ API
  final List<Map<String, String>> academicYears = [
    {'id': '1', 'label': 'my_courses_screen.first_year'},
    {'id': '2', 'label': 'my_courses_screen.second_year'},
    {'id': '3', 'label': 'my_courses_screen.third_year'},
    {'id': '4', 'label': 'my_courses_screen.fourth_year'},
    {'id': '5', 'label': 'my_courses_screen.fifth_year'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // نستخدم didChangeDependencies للحصول على provider بشكل آمن لمرة واحدة
    _settings = Provider.of<SettingsProvider>(context);

    // التحقق من صحة القيمة المخزنة، إذا لم تكن رقماً نضع القيمة الافتراضية '1'
    String currentYearId = _settings.academicYear;
    if (!academicYears.any((year) => year['id'] == currentYearId)) {
      currentYearId = '1';
      // لا نحتاج لانتظار الحفظ هنا، فقط نغير القيمة في الذاكرة بصمت
      Future.microtask(() => _settings.changeAcademicYear(currentYearId));
    }

    // جلب البيانات بناءً على السنة الحالية
    _coursesFuture = _fetchCourses(currentYearId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // دالة جلب المقررات مقسمة إلى فصلين بناءً على السنة
  Future<Map<String, List<Map<String, dynamic>>>> _fetchCourses(String yearId) async {
    // نفترض أن API يقبل المتغير year
    String url = '${ApiConstants.getSubjects}?year=$yearId';
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {
            'term1': List<Map<String, dynamic>>.from(data['data']['term1'] ?? []),
            'term2': List<Map<String, dynamic>>.from(data['data']['term2'] ?? []),
          };
        }
      }
    } catch (e) {
      debugPrint('خطأ في جلب المقررات: $e');
    }
    return {'term1': [], 'term2': []};
  }

  void _onYearChanged(String? newYearId) {
    if (newYearId != null) {
      _settings.changeAcademicYear(newYearId);
      setState(() {
        // إعادة جلب البيانات عند تغيير السنة
        _coursesFuture = _fetchCourses(newYearId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _settings.isDarkMode;
    const Color primaryGreen = Color(0xFF2E7D32);

    final String yearLabel = widget.role == UserRole.student
        ? 'my_courses_screen.academic_year_label'.tr()
        : 'my_courses_screen.teaching_year_label'.tr();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // الترويسة العلوية والقائمة المنسدلة للسنوات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),

                // 👈 وضعنا عناصر اختيار السنة داخل Expanded لكي تتقلص وتتوسط تلقائياً بدون تجاوز
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        yearLabel,
                        style: TextStyle(
                          fontSize: 11, // تصغير الحجم طفيفاً لضمان عدم الازدحام
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryGreen.withOpacity(0.5)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isDense: true,
                            value: academicYears.any((y) => y['id'] == _settings.academicYear)
                                ? _settings.academicYear
                                : '1',
                            dropdownColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                            icon: const Icon(Icons.keyboard_arrow_down, color: primaryGreen, size: 16),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                            items: academicYears.map((yearMap) => DropdownMenuItem<String>(
                              value: yearMap['id'],
                              child: Text(yearMap['label']!.tr()),
                            )).toList(),
                            onChanged: _onYearChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.black87),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
                ),
              ],
            ),
          ),

          // شريط البحث
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

          // تبويبات الترم الأول والثاني
          Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: primaryGreen,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryGreen,
              labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: 'my_courses_screen.first_term'.tr()),
                Tab(text: 'my_courses_screen.second_term'.tr()),
              ],
            ),
          ),

          // محتوى التبويبات (المقررات)
          Expanded(
            child: widget.role == UserRole.guest
                ? _buildLoginRequiredState(isDarkMode, primaryGreen, context)
                : FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: primaryGreen));
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text('تعذر الاتصال بالخادم', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }

                final term1Courses = snapshot.data?['term1'] ?? [];
                final term2Courses = snapshot.data?['term2'] ?? [];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildCoursesGrid(term1Courses, context),
                    _buildCoursesGrid(term2Courses, context),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // بناء شبكة المقررات (تم تغييرها لتدعم UnifiedItemCard كـ Grid)
  Widget _buildCoursesGrid(List<Map<String, dynamic>> courses, BuildContext context) {
    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 10),
            Text('لا توجد مقررات في هذا الفصل', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final subject = courses[index];
        return UnifiedItemCard(
          title: subject['title'] ?? 'مقرر بدون اسم',
          subtitle: subject['subtitle'] ?? '',
          icon: Icons.menu_book_rounded, // يمكنك تخصيص الأيقونة برمجياً لاحقاً
          isGridView: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectDetailsScreen(
                  subjectName: subject['title'] ?? 'تفاصيل المقرر',
                  subjectId: int.tryParse(subject['id'].toString()) ?? 0,
                  role: widget.role,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLoginRequiredState(bool isDarkMode, Color primaryGreen, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_person_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              'محتوى أكاديمي مقفل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            Text(
              'المقررات الدراسية والمحاضرات متاحة فقط للطلاب والأساتذة. يرجى تسجيل الدخول للوصول إلى مناهجك.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}