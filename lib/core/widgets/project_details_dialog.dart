import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailsDialog({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Dialog(
      // 👇 تقليل الحواف الخارجية لكي تأخذ النافذة مساحة أكبر من الشاشة
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      clipBehavior: Clip.antiAlias, // 👈 مهم جداً لقص الصورة مع الحواف الدائرية للنافذة
      elevation: 10,
      child: SingleChildScrollView( // 👈 لضمان عدم حدوث خطأ Overflow في الشاشات الصغيرة
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. غلاف المشروع (صورة كبيرة في الأعلى)
            // ==========================================
            Container(
              height: 220, // 👈 ارتفاع كبير للصورة
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                image: project['image'] != null
                    ? DecorationImage(
                  // يمكنك استخدام AssetImage إذا كانت الصورة محلية
                  image: NetworkImage(project['image']),
                  fit: BoxFit.cover, // لتعبئة المساحة بالكامل
                )
                    : null,
              ),
              // أيقونة بديلة في حال لم يتم تمرير صورة
              child: project['image'] == null
                  ? Icon(Icons.architecture, size: 60, color: Colors.grey.shade400)
                  : null,
            ),

            // ==========================================
            // 2. تفاصيل المشروع
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(24.0), // حواف داخلية مريحة للعين
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان + السنة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          project['title'],
                          style: TextStyle(
                            fontSize: 22, // تكبير خط العنوان
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            fontFamily: 'Cairo',
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'project_details_dialog.class_of'.tr(args: [project['year'].toString()]),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // النبذة (الوصف)
                  Text(
                    'project_details_dialog.about_project'.tr(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project['description'] ?? 'project_details_dialog.no_additional_details'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(height: 1),
                  ),

                  // تفاصيل الطلاب والمشرف
                  _buildDetailRow(Icons.group, 'project_details_dialog.prepared_by'.tr(), project['students'], isDarkMode),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.person, 'project_details_dialog.academic_supervision'.tr(), project['supervisor'], isDarkMode),

                  const SizedBox(height: 32), // مساحة إضافية قبل الأزرار

                  // ==========================================
                  // 3. أزرار الإجراءات (قراءة / تحميل)
                  // ==========================================
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // إغلاق النافذة
                            print('project_details_dialog.opening_project'.tr());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14), // تكبير حجم الزر
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.menu_book, size: 22),
                          label: Text('project_details_dialog.read'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context); // إغلاق النافذة
                            print('project_details_dialog.downloading_project'.tr());
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryGreen,
                            side: const BorderSide(color: primaryGreen, width: 1.5), // خط خارجي أوضح
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.file_download, size: 22),
                          label: Text('project_details_dialog.download'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء صفوف التفاصيل بتنسيق أوضح وأكبر
  Widget _buildDetailRow(IconData icon, String label, String value, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
        const SizedBox(width: 10),
        Text(
          '$label ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
