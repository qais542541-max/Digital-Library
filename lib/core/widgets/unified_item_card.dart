import 'package:flutter/material.dart';

class UnifiedItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isGridView;
  final VoidCallback? onTap; // أمر الضغط على البطاقة لفتحها
  final VoidCallback? onDownload; // أمر الضغط على زر التنزيل (اختياري)

  const UnifiedItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isGridView,
    this.onTap,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    // 1. هذا السطر يسأل التطبيق: هل نحن في الوضع المظلم الآن؟
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // استخدمنا InkWell ليعطي تأثيراً بصرياً (تموج) عند الضغط على البطاقة
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        // 2. السحر هنا: إذا كان مظلماً نجعله رمادياً داكناً، وإلا نجعله أبيض
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        elevation: 4,

        // 3. نخفي الظل في الوضع المظلم ليكون التصميم أنظف
        shadowColor: isDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.4),

        shape: RoundedRectangleBorder(
          // 4. نخفي الحدود البيضاء في الوضع المظلم
          side: BorderSide(
              color: isDarkMode ? Colors.transparent : Colors.grey.shade100,
              width: 1
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: isGridView
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2E7D32), size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              // لم نحدد لون النص هنا لكي يأخذ اللون الأبيض تلقائياً في الوضع المظلم
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        )
            : ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Icon(icon, color: const Color(0xFF2E7D32), size: 40),
          title: Text(
            title,
            // لم نحدد لون النص هنا أيضاً
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: onDownload != null
              ? IconButton(
            icon: const Icon(Icons.download_rounded, color: Color(0xFF2E7D32)),
            onPressed: onDownload,
          )
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}