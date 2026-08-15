import 'package:flutter/material.dart';
import '../../features/layout/screens/main_screen.dart';

class ResourceItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final UserRole role;
  final VoidCallback onTap;
  final VoidCallback onDownload;
  final Function(String)? onTeacherAction;

  const ResourceItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.role,
    required this.onTap,
    required this.onDownload,
    this.onTeacherAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDarkMode ? Colors.transparent : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 1. أيقونة الملف (البداية: ستظهر يميناً في العربية ويساراً في الإنجليزية)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),

                // 2. اسم الملف والتفاصيل (المنتصف)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // start يتكيف تلقائياً مع لغة التطبيق
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 3. زر التنزيل والخيارات (النهاية: ستظهر يساراً في العربية ويميناً في الإنجليزية)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // زر التنزيل باللون الأخضر
                    IconButton(
                      icon: const Icon(Icons.file_download_outlined, color: primaryGreen, size: 24),
                      onPressed: onDownload,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    // خيارات المعلم (تظهر فقط للمعلمين)
                    if (role == UserRole.teacher || role == UserRole.employee) ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 22),
                        onSelected: onTeacherAction,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit, color: Colors.blue, size: 20), SizedBox(width: 8), Text('تعديل')])),
                          const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete, color: Colors.red, size: 20), SizedBox(width: 8), Text('حذف')])),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}