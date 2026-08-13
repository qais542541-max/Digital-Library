import 'package:flutter/material.dart';
import '../../core/widgets/custom_drawer.dart'; // استدعاء ملف ايقونة القائمة الجانبية
import '../../core/widgets/notifications_screen.dart'; // استدعاء ملف ايقونة القائمة الجانبية
import '../../features/layout/screens/main_screen.dart';


class AiAssistantScreen extends StatelessWidget {
  final UserRole role; // 1. تعريف المتغير هنا

  const AiAssistantScreen({super.key, required this.role}); // 2. إشراط استقباله هنا

  @override
  Widget build(BuildContext context) {
    // 1. قراءة حالة الثيم لمعرفة ما إذا كان التطبيق في الوضع المظلم
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'المساعد الذكي',
          // إزالة اللون الثابت لكي يستمع لثيم التطبيق تلقائياً (أبيض أو أسود)
          style: TextStyle(
            color: isDarkMode ? Colors.white : const Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  );
                },
              ),
              Positioned(
                top: 8,
                right: 8,
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
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // منطقة عرض الرسائل
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildChatBubble(
                  text: 'أهلاً بك! كيف يمكنني مساعدتك في دراستك اليوم؟',
                  isAi: true,
                  isDarkMode: isDarkMode, // تمرير الحالة هنا
                ),
                _buildChatBubble(
                  text: 'أين أجد ملزمة جودة البرمجيات؟',
                  isAi: false,
                  isDarkMode: isDarkMode,
                ),
                _buildChatBubble(
                  text: 'ملزمة جودة البرمجيات موجودة في قسم: السنة الثالثة ⬅️ الترم الأول. هل تريدني أن أنقلك إليها مباشرة؟',
                  isAi: true,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          // شريط كتابة الرسالة في الأسفل
          _buildInputField(isDarkMode),
        ],
      ),
      drawer: CustomDrawer(role: role),
    );
  }

  // 2. دالة مساعدة لبناء فقاعة المحادثة الذكية (أضفنا معامل isDarkMode)
  Widget _buildChatBubble({required String text, required bool isAi, required bool isDarkMode}) {
    return Align(
      // محاذاة لليمين للذكاء الاصطناعي، ولليسار للطالب
      alignment: isAi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280), // أقصى عرض للفقاعة
        decoration: BoxDecoration(
          // سحر الألوان: إذا كانت رسالة AI وفي الوضع المظلم اجعلها رمادية داكنة، وإلا فاتحة
          color: isAi
              ? (isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100)
              : const Color(0xFF2E7D32), // رسالة الطالب تظل خضراء دائماً

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            // تغيير شكل الحافة السفلية بناءً على المرسل
            bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(15),
            bottomRight: isAi ? const Radius.circular(15) : const Radius.circular(0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            // إذا كانت رسالة AI في الوضع المظلم النص أبيض، وإلا أسود. ورسالة الطالب دائماً بيضاء
            color: isAi
                ? (isDarkMode ? Colors.white : Colors.black87)
                : Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // 3. دالة مساعدة لبناء حقل إدخال النص (أضفنا معامل isDarkMode)
  Widget _buildInputField(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // خلفية الشريط السفلي تتغير حسب الثيم
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        boxShadow: [
          BoxShadow(
            // إخفاء الظل في الوضع المظلم لتجنب التشوه البصري
            color: isDarkMode ? Colors.transparent : Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              // تغيير لون النص المكتوب ليكون مرئياً في الوضع المظلم
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: 'اسأل عن أي مادة أو ملزمة...',
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                // تغيير لون حقل الإدخال الداخلي
                fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
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
                // سيتم برمجة كود الإرسال لـ Gemini API مستقبلاً هنا
                print('تم الضغط على زر الإرسال');
              },
            ),
          ),
        ],
      ),
    );
  }
}