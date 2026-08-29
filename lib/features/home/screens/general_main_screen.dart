import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:digital_library/core/providers/settings_provider.dart';
import 'package:digital_library/core/widgets/unified_item_card.dart';
import 'package:digital_library/core/widgets/notifications_screen.dart';
import 'my_loans_screen.dart';

class GeneralMainScreen extends StatelessWidget {
  final String userName;
  final String userRole;

  const GeneralMainScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,

      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // الترويسة العلوية الموحدة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Text(
                    'general_main_screen.title'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.black87),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                        },
                      ),
                      Positioned(
                        top: 10,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. الترحيب وشريط البحث
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'general_main_screen.welcome_msg'.tr(args: [userName]),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'general_main_screen.role'.tr(args: [userRole]),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'general_main_screen.learn_today'.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // شريط البحث
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo'),
                              decoration: InputDecoration(
                                hintText: 'general_main_screen.search_hint'.tr(),
                                hintStyle: TextStyle(color: Colors.grey.shade500, fontFamily: 'Cairo'),
                                prefixIcon: const Icon(Icons.search, color: primaryGreen),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),


                    // 2. الوصول السريع المجمع (أزرار تفاعلية بتصميم حديث)
                    // 2. الوصول السريع المجمع (3 أزرار تفاعلية بتوزيع متناسق)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. مشاريع التخرج
                            _buildInteractiveQuickAction(
                              icon: Icons.architecture,
                              label: 'general_main_screen.projects'.tr(),
                              color: primaryGreen,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                print("تم الضغط على المشاريع");
                              },
                            ),
                            // 2. موقع الكلية
                            _buildInteractiveQuickAction(
                              icon: Icons.language,
                              label: 'general_main_screen.website'.tr(),
                              color: primaryGreen,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                print("تم الضغط على الموقع");
                              },
                            ),
                            // 3. استعاراتي
                            _buildInteractiveQuickAction(
                              icon: Icons.assignment_return_outlined,
                              label: 'general_main_screen.my_loans'.tr(),
                              color: primaryGreen,
                              isDarkMode: isDarkMode,
                              onTap: () {
                                // 👇 الانتقال إلى شاشة الاستعارات الجديدة
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyLoansScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 3. أحدث الإضافات (Horizontal Scroll)
                    _buildSectionTitle('general_main_screen.recently_added'.tr(), isDarkMode),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 140,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: UnifiedItemCard(
                              title: 'general_main_screen.advanced_programming'.tr(),
                              subtitle: 'general_main_screen.doctor_name'.tr(),
                              icon: Icons.picture_as_pdf,
                              isGridView: true,
                              onTap: () {},
                              onDownload: () {},
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 👇 4. الإضافات المميزة (Horizontal Scroll - القسم الجديد)
                    _buildSectionTitle('general_main_screen.featured_additions'.tr(), isDarkMode),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 140,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: UnifiedItemCard(
                              title: 'general_main_screen.featured_item'.tr(), // نص افتراضي حتى يتم ربطه
                              subtitle: 'general_main_screen.doctor_name'.tr(),
                              icon: Icons.star_border_rounded, // أيقونة تميز نجمة
                              isGridView: true,
                              onTap: () {},
                              onDownload: () {},
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),

                    // 5. إعلانات وأخبار الكلية (Vertical List)
                    _buildSectionTitle('general_main_screen.college_news'.tr(), isDarkMode),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.campaign, color: primaryGreen),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'general_main_screen.defense_title'.tr(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isDarkMode ? Colors.white : Colors.black87,
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'general_main_screen.defense_desc'.tr(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // 6. قسم التواصل السريع
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDarkMode
                                ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                                : [primaryGreen, const Color(0xFF1B5E20)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode ? Colors.black26 : primaryGreen.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'general_main_screen.need_help'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'general_main_screen.support_team'.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white70,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildContactButton(Icons.phone, 'general_main_screen.call'.tr(), () {}),
                                _buildContactButton(Icons.map_outlined, 'general_main_screen.location'.tr(), () {}),
                                _buildContactButton(Icons.email_outlined, 'general_main_screen.email'.tr(), () {}),
                              ],
                            ),

                            const SizedBox(height: 20),
                            const Divider(color: Colors.white24),
                            const SizedBox(height: 10),

                            Text(
                              'general_main_screen.copyright'.tr(),
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white54,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  // دالة بناء أزرار الوصول السريع التفاعلية الحديثة
  Widget _buildInteractiveQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return Expanded( // لتوزيع المساحات بالتساوي وتجنب أخطاء تجاوز الشاشة
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: color.withOpacity(0.2), // لون التموج عند الضغط
          highlightColor: color.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    // تصميم المربع الدائري (Squircle) بدلاً من الدائرة
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2, // يسمح للنص بالنزول لسطرين بكل أناقة
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'Cairo'),
            ),
          ],
        ),
      ),
    );
  }
}