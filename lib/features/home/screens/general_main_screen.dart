import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/notifications_screen.dart'; // مسار شاشة الإشعارات

class GeneralMainScreen extends StatelessWidget {
  final String userName; // 👈 متغير لاستقبال الاسم
  final String userRole; // 👈 متغير لاستقبال الصفة

  const GeneralMainScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // ... (باقي الكود كما هو)
    const Color primaryGreen = Color(0xFF2E7D32);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final isArabic = settings.languageCode == 'ar';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          isArabic ? 'الرئيسية' : 'Home',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // زر الإشعارات مع العداد (Badge)
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
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
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
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
                    isArabic ? 'مرحباً، $userName! 👋' : 'Welcome, $userName! 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isArabic ? 'الصفة: $userRole' : 'Role: $userRole', // 👈 استخدمنا الصفة هنا أيضاً
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isArabic ? 'ماذا تريد أن تتعلم اليوم؟' : 'What do you want to learn today?',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
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
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        hintText: isArabic ? 'ابحث عن ملازم، مشاريع، محاضرات...' : 'Search for books, projects...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
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

            // 2. الوصول السريع (Quick Actions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildQuickAction(Icons.video_library, isArabic ? 'المحاضرات' : 'Lectures', primaryGreen, isDarkMode),
                  _buildQuickAction(Icons.architecture, isArabic ? 'المشاريع' : 'Projects', primaryGreen, isDarkMode),
                  _buildQuickAction(Icons.menu_book, isArabic ? 'الكتب الورقية' : 'Books', primaryGreen, isDarkMode),
                  _buildQuickAction(Icons.article_outlined, isArabic ? 'الإعلانات' : 'News', primaryGreen, isDarkMode),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. أحدث الإضافات (Horizontal Scroll)
            _buildSectionTitle(isArabic ? 'أحدث الإضافات للمكتبة' : 'Recently Added', isDarkMode),
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
                      title: isArabic ? 'ملزمة برمجة متقدمة' : 'Advanced Programming',
                      subtitle: 'د. أحمد محمد',
                      icon: Icons.picture_as_pdf,
                      isGridView: true, // شكل شبكي للبطاقات الأفقية
                      onTap: () {},
                      onDownload: () {},
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 25),

            // 4. إعلانات وأخبار الكلية (Vertical List)
            _buildSectionTitle(isArabic ? 'أخبار وإعلانات الكلية' : 'College News', isDarkMode),
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
                                isArabic ? 'موعد مناقشة مشاريع التخرج' : 'Graduation Projects Defense',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? 'تم تحديد موعد مناقشة مشاريع التخرج لقسم البرمجة...' : 'The date for the projects defense has been set...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
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
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء عنوان القسم
  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  // دالة مساعدة لبناء أزرار الوصول السريع
  Widget _buildQuickAction(IconData icon, String label, Color color, bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey.shade300 : Colors.black87,
          ),
        ),
      ],
    );
  }
}