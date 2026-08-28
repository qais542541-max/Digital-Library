import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/layout/screens/main_screen.dart';

class ResourceItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final UserRole role;
  final VoidCallback onTap;

  final VoidCallback? onDownload;
  final IconData? actionIcon;

  // 👇 1. تعميم الشارة لتستخدم للرفوف أو لنوع المادة (نظري/عملي)
  final String? badgeText;
  final Color? badgeColor;
  final IconData? badgeIcon;

  final Function(String)? onTeacherAction;

  const ResourceItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.role,
    required this.onTap,
    this.onDownload,
    this.actionIcon,
    this.badgeText,  // استقبال نص الشارة
    this.badgeColor, // استقبال لون الشارة
    this.badgeIcon,  // استقبال أيقونة الشارة
    this.onTeacherAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    // اللون الافتراضي للشارة إذا لم يتم تمرير لون
    final Color effectiveBadgeColor = badgeColor ?? const Color(0xFFE65100);

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
                // أيقونة الملف الرئيسية
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: badgeText != null ? effectiveBadgeColor : primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),

                // اسم الملف والتفاصيل
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

                      // 👇 2. الشارة الديناميكية (للرفوف أو نظري/عملي)
                      if (badgeText != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDarkMode ? effectiveBadgeColor.withOpacity(0.15) : effectiveBadgeColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: effectiveBadgeColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(badgeIcon ?? Icons.info_outline, color: effectiveBadgeColor, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                badgeText!,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode ? Colors.white : effectiveBadgeColor,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // زر الإجراء (تنزيل/فيديو) والخيارات
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onDownload != null)
                      IconButton(
                        icon: Icon(actionIcon ?? Icons.file_download_outlined, color: primaryGreen, size: 24),
                        onPressed: onDownload,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),

                    if (role == UserRole.teacher || role == UserRole.employee) ...[
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey, size: 22),
                        onSelected: onTeacherAction,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit, color: Colors.blue, size: 20),
                                const SizedBox(width: 8),
                                Text('تعديل')
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Text('حذف')
                              ],
                            ),
                          ),
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