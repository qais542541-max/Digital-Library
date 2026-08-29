import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/widgets/notifications_screen.dart';
import '../../features/layout/screens/main_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/settings_provider.dart';

class AiAssistantScreen extends StatelessWidget {
  final UserRole role;

  const AiAssistantScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final settings = Provider.of<SettingsProvider>(context);

    // إزالة Scaffold واستبداله بـ SafeArea و Column
    return SafeArea(
      child: Column(
        children: [
          // 👇 1. الترويسة المخصصة (بدون AppBar) 👇
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر القائمة الجانبية (يفتح الـ Drawer الخاص بـ MainScreen)
                IconButton(
                  icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black87),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),

                // العنوان في المنتصف
                Text(
                  'ai_assistant_screen.title'.tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF2E7D32),
                    fontFamily: 'Cairo', // توحيد الخط
                  ),
                ),

                // زر الإشعارات
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_outlined, color: isDarkMode ? Colors.white : Colors.black87),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
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
              ],
            ),
          ),

          // 👇 2. محتوى المحادثة 👇
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  text: 'ai_assistant_screen.welcome_msg'.tr(),
                  isAi: true,
                  isDarkMode: isDarkMode,
                ),
                _buildChatBubble(
                  text: 'ai_assistant_screen.user_query_example'.tr(),
                  isAi: false,
                  isDarkMode: isDarkMode,
                ),
                _buildChatBubble(
                  text: 'ai_assistant_screen.ai_response_example'.tr(),
                  isAi: true,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          // 👇 3. شريط إدخال النص في الأسفل 👇
          _buildInputField(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildChatBubble({required String text, required bool isAi, required bool isDarkMode}) {
    return Align(
      alignment: isAi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isAi
              ? (isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100)
              : const Color(0xFF2E7D32),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(15),
            bottomRight: isAi ? const Radius.circular(15) : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isAi ? (isDarkMode ? Colors.white : Colors.black87) : Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      // 👇 تم إزالة BoxDecoration الذي كان يسبب المستطيل الأبيض والظل
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'ai_assistant_screen.input_hint'.tr(),
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                // يمكنك تفتيح لون حقل النص قليلاً في الوضع الفاتح ليكون بارزاً
                fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF2E7D32),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () {
                print('ai_assistant_screen.send_button_pressed'.tr());
              },
            ),
          ),
        ],
      ),
    );
  }
}
