import 'package:flutter/material.dart';

class UnifiedItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isGridView;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        // 👇 السحر هنا: توحيد التصميم والظلال مع شاشة الرئيسية (Jaib Style)
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white, // نفس لون حاويات الرئيسية
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: isDarkMode ? Colors.transparent : Colors.grey.shade200,
              width: 1
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.04), // ظل خفيف للعمق
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
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