import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
        title: Text('notifications_screen.title'.tr()),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // عدد وهمي للإشعارات
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: UnifiedItemCard(
              title: index == 0 
                  ? 'notifications_screen.system_update_title'.tr() 
                  : 'notifications_screen.dean_notification_title'.tr(),
              subtitle: index == 0 
                  ? 'notifications_screen.system_update_desc'.tr() 
                  : 'notifications_screen.graduation_projects_desc'.tr(),
              icon: index == 0 ? Icons.campaign : Icons.notifications_active,
              isGridView: false,
              onTap: () {
                // تفاصيل الإشعار عند الضغط عليه
                print('notifications_screen.notification_opened_msg'.tr(args: [index.toString()]));
              },
              onDownload: null, // لا نحتاج زر تنزيل هنا، سيظهر سهم الانتقال تلقائياً
            ),
          );
        },
      ),
    );
  }
}
