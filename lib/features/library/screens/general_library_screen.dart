import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart';
import '../../../core/widgets/advanced_search_bottom_sheet.dart'; // 👈 استدعاء نافذة البحث المتقدم
import '../../layout/screens/main_screen.dart';
import 'books_list_screen.dart';

class GeneralLibraryScreen extends StatefulWidget {
  final UserRole role;

  const GeneralLibraryScreen({super.key, required this.role});

  @override
  State<GeneralLibraryScreen> createState() => _GeneralLibraryScreenState();
}

// 👇 تحويلها لـ Stateful واستخدام التبويبات
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
    ];

    final List<Map<String, dynamic>> publicLibraryCategories = [
      {
        'title': 'general_library_screen.programming_references'.tr(),
        'icon': Icons.computer,
        'subtitle': 'general_library_screen.programming_references_subtitle'.tr()
      },
    ];

    return SafeArea(
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
                      // التبويب الأول (index 0) هو المكتبة الورقية
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
              controller: _tabController, // 👈 ربط المتحكم
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
              controller: _tabController, // 👈 ربط المتحكم
              children: [
                _buildLibraryGrid(context, collegeLibraryCategories, false),
                _buildLibraryGrid(context, publicLibraryCategories, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryGrid(BuildContext context, List<Map<String, dynamic>> categories, bool isPublic) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
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
