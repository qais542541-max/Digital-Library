import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../../core/widgets/advanced_search_bottom_sheet.dart';
import 'package:digital_library/features/layout/screens/main_screen.dart';
import 'package:digital_library/features/library/screens/books_list_screen.dart';

// 👇 تأكد من استدعاء شاشة تسجيل الدخول هنا (قم بتعديل المسار حسب مشروعك)
import '../../login//screens/login_screen.dart';

class GeneralLibraryScreen extends StatefulWidget {
  final UserRole role;

  const GeneralLibraryScreen({super.key, required this.role});

  @override
  State<GeneralLibraryScreen> createState() => _GeneralLibraryScreenState();
}

class _GeneralLibraryScreenState extends State<GeneralLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    const Color primaryGreen = Color(0xFF2E7D32);

    final List<Map<String, dynamic>> collegeLibraryCategories = [
      {
        'title': 'general_library_screen.graduation_projects'.tr(),
        'icon': Icons.account_tree,
        'subtitle': 'general_library_screen.graduation_projects_subtitle'.tr()
      },
      {
        'title': 'الكتب المنهجية والمراجع',
        'icon': Icons.library_books,
        'subtitle': 'مقررات جميع التخصصات الأكاديمية'
      },
      {
        'title': 'رسائل وأبحاث علمية',
        'icon': Icons.school,
        'subtitle': 'أبحاث التخرج والدراسات العليا'
      },
    ];

    final List<Map<String, dynamic>> publicLibraryCategories = [
      {
        'title': 'general_library_screen.programming_references'.tr(),
        'icon': Icons.computer,
        'subtitle': 'general_library_screen.programming_references_subtitle'.tr()
      },
    ];

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                Text(
                  'general_library_screen.title'.tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : primaryGreen, fontFamily: 'Cairo'),
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
            child: Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune, color: primaryGreen, size: 20),
                    onPressed: () {
                      final bool isPhysicalTabActive = _tabController.index == 0;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AdvancedSearchBottomSheet(isPhysicalLibrary: isPhysicalTabActive),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
                        hintText: 'general_library_screen.search_hint'.tr(),
                        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontFamily: 'Cairo'),
                        prefixIcon: const Icon(Icons.search, color: primaryGreen, size: 20),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Container(
            color: Colors.transparent,
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              labelColor: primaryGreen,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryGreen,
              tabs: [
                Tab(text: 'general_library_screen.physical_library'.tr()),
                Tab(text: 'general_library_screen.digital_library'.tr()),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // التبويب الأول: المكتبة الورقية (مغلق للضيف)
                widget.role == UserRole.guest
                    ? _buildLoginRequiredState(isDarkMode, primaryGreen, context) // 👈 تم تمرير context هنا للتنقل
                    : _buildLibraryGrid(context, collegeLibraryCategories, false),

                // التبويب الثاني: المكتبة الرقمية (متاح للجميع)
                _buildLibraryGrid(context, publicLibraryCategories, true),
              ],
            ),
          ),
        ],
      ),
    );
  } // 👈 هنا تنتهي دالة build الأساسية

  // 👇 الدوال المساعدة توضع هنا، خارج دالة build

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
              'محتوى مقفل',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 10),
            Text(
              'المكتبة الورقية متاحة فقط للطلاب والأساتذة المسجلين. يرجى تسجيل الدخول للاستعارة وحجز الكتب.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // 👇 توجيه الضيف إلى شاشة تسجيل الدخول
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('تسجيل الدخول / تفعيل حساب', style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
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

  Widget _buildLibraryGrid(BuildContext context, List<Map<String, dynamic>> categories, bool isPublic) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), // 👈 حشوة سفلية ليظهر التلاشي بشكل سليم
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return UnifiedItemCard(
          title: categories[index]['title'],
          subtitle: categories[index]['subtitle'],
          icon: categories[index]['icon'],
          isGridView: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BooksListScreen(
                  categoryName: categories[index]['title'],
                  categoryId: 5,
                  subjectId: 0,
                  role: widget.role,
                  isPublicLibrary: isPublic,
                ),
              ),
            );
          },
        );
      },
    );
  }
}