import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../../core/widgets/unified_item_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(settings.languageCode == 'ar' ? 'الإشعارات والتنبيهات' : 'Notifications'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // عدد وهمي للإشعارات
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: UnifiedItemCard(
              title: index == 0 ? 'تحديث نظام المكتبة' : 'إشعار جديد من عمادة الكلية',
              subtitle: index == 0 ? 'تمت إضافة ميزة التنزيل للمقررات الدراسية - منذ ساعتين' : 'موعد تسليم مشاريع التخرج يقترب - أمس',
              icon: index == 0 ? Icons.campaign : Icons.notifications_active,
              isGridView: false,
              onTap: () {
                // تفاصيل الإشعار عند الضغط عليه
                print('تم فتح الإشعار رقم $index');
              },
              onDownload: null, // لا نحتاج زر تنزيل هنا، سيظهر سهم الانتقال تلقائياً
            ),
          );
        },
      ),
    );
  }
}