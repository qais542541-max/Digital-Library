import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final isArabic = settings.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'من نحن' : 'About Us'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. القسم الرئيسي (Hero / Main Card)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book, color: primaryGreen, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isArabic ? 'مكتبة كلية المجتمع صنعاء' : 'Sanaa Community College Library',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isArabic
                      ? 'تُعد المكتبة الرقمية لكلية المجتمع صنعاء من أبرز المكتبات الأكاديمية في اليمن، حيث تسعى لتقديم أفضل الخدمات المكتبية لطلاب الكلية وأعضاء هيئة التدريس والباحثين. نحن نفر الوصل إلى مجموعة واسعة من الكتب والمصادر الرقمية والأكاديمية لدعم العملية التعليمية والبحثية.\n\nتأسست المكتبة بهدف أساسي هو توفير بيئة تعليمية غنية بالموارد المعرفية، حيث نحرص على تحديث مكتباتنا باستمرار لإضافة أحدث الإصدارات والكتب المرجع في مجالات المجتمع المختلفة.'
                      : 'The Digital Library of Sanaa Community College is one of the premier academic libraries in Yemen, striving to provide the best library services to college students, faculty members, and researchers.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. شبكة الرؤية، الرسالة، والقيم (Vision, Mission, Values)
          _buildValueCard(
            context,
            icon: Icons.visibility,
            title: isArabic ? 'رؤيتنا' : 'Our Vision',
            text: isArabic
                ? 'أن نكون مركزاً للتميز في تقديم الخدمات المكتبية والبحثية، والمساهمة في دعم العملية التعليمية والبحثية، ومواكبة التطورات التقنية في مجال المعلومات.'
                : 'To be a center of excellence in providing library and research services.',
            isDarkMode: isDarkMode,
            primaryColor: primaryGreen,
          ),
          const SizedBox(height: 16),
          _buildValueCard(
            context,
            icon: Icons.track_changes,            title: isArabic ? 'رسالتنا' : 'Our Mission',
            text: isArabic
                ? 'توفر المصادر المعلوماتية والخدمات المكتبية عالية الجودة لدعم البحث العلمي والتعلم المستمر، وتلبية احتياجات المستخدمين بأحدث التقنيات.'
                : 'Providing high-quality informational resources and library services.',
            isDarkMode: isDarkMode,
            primaryColor: primaryGreen,
          ),
          const SizedBox(height: 16),
          _buildValueCard(
            context,
            icon: Icons.diamond_outlined,
            title: isArabic ? 'قيمنا' : 'Our Values',
            text: isArabic
                ? 'الجودة والابتكار والتعاون وخدمة المجتمع الأكاديمي باحترام ومهنية عالية، مع الالتزام بأعلى معايير الخدمة.'
                : 'Quality, innovation, cooperation, and serving the academic community.',
            isDarkMode: isDarkMode,
            primaryColor: primaryGreen,
          ),
          const SizedBox(height: 24),

          // 3. قسم الإحصائيات (Statistics Section)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  isArabic ? 'إحصائيات المكتبة' : 'Library Statistics',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildStatItem('+50,000', isArabic ? 'كتاب رقمي' : 'Digital Books'),
                    _buildStatItem('+2,000', isArabic ? 'طالب عضو' : 'Member Students'),
                    _buildStatItem('+500', isArabic ? 'مصدر أكاديمي' : 'Academic Source'),
                    _buildStatItem('24/7', isArabic ? 'خدمة متاحة' : 'Available Service'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // بطاقة الرؤية/الرسالة/القيم الموحدة
  Widget _buildValueCard(BuildContext context, {required IconData icon, required String title, required String text, required bool isDarkMode, required Color primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // عنصر الإحصائيات الفردي
  Widget _buildStatItem(String number, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}