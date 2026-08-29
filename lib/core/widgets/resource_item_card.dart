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

  final String? shelfLocation;
  final bool? isBorrowed;
  final bool? isPractical; // 👈 متغير نوع المادة (عملي/نظري)

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
    this.shelfLocation,
    this.isBorrowed,
    this.isPractical,
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
                // 1. أيقونة الملف الرئيسية
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),

                // 2. اسم الملف، الأستاذ، وشارة النظري/عملي
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان الأساسي
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

                      // 👇 سطر الأستاذ + شارة النظري/عملي متباعدين
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                                fontFamily: 'Cairo',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // لضمان عدم تداخل الأسماء الطويلة مع الشارة
                            ),
                          ),

                          // الشارة (Tag) بدون أيقونات ومحاذية للطرف
                          if (isPractical != null)
                            Container(
                              margin: const EdgeInsetsDirectional.only(start: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isPractical!
                                    ? Colors.blue.withOpacity(isDarkMode ? 0.15 : 0.08)
                                    : primaryGreen.withOpacity(isDarkMode ? 0.15 : 0.08),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isPractical! ? Colors.blue.withOpacity(0.3) : primaryGreen.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                isPractical! ? 'عملي' : 'نظري',
                                style: TextStyle(
                                  fontSize: 10, // خط أصغر لتبدو كشارة أنيقة
                                  fontWeight: FontWeight.bold,
                                  color: isPractical!
                                      ? Colors.blue
                                      : (isDarkMode ? Colors.green.shade300 : primaryGreen),
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                        ],
                      ),

                      // الشارات القديمة للرفوف وحالة الإعارة (تم الإبقاء عليها بالأسفل إذا احتجتها مستقبلاً)
                      if (shelfLocation != null || isBorrowed != null) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (shelfLocation != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? primaryGreen.withOpacity(0.15) : primaryGreen.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: primaryGreen.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.shelves, color: primaryGreen, size: 14),
                                    const SizedBox(width: 4),
                                    Text('الرف: $shelfLocation', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.green.shade300 : primaryGreen, fontFamily: 'Cairo')),
                                  ],
                                ),
                              ),

                            if (isBorrowed != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isBorrowed! ? Colors.red.withOpacity(isDarkMode ? 0.15 : 0.08) : primaryGreen.withOpacity(isDarkMode ? 0.15 : 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: isBorrowed! ? Colors.red.withOpacity(0.3) : primaryGreen.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(isBorrowed! ? Icons.do_not_disturb_alt : Icons.check_circle_outline, color: isBorrowed! ? Colors.red : primaryGreen, size: 14),
                                    const SizedBox(width: 4),
                                    Text(isBorrowed! ? 'معار' : 'متاح', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isBorrowed! ? Colors.red : (isDarkMode ? Colors.green.shade300 : primaryGreen), fontFamily: 'Cairo')),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 3. أزرار الإجراءات
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
                          PopupMenuItem(value: 'edit', child: Row(children: [const Icon(Icons.edit, color: Colors.blue, size: 20), const SizedBox(width: 8), Text('resource_item_card.edit'.tr())])),
                          PopupMenuItem(value: 'delete', child: Row(children: [const Icon(Icons.delete, color: Colors.red, size: 20), const SizedBox(width: 8), Text('resource_item_card.delete'.tr())])),
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