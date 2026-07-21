import 'package:flutter/material.dart';
import '../core/widgets/custom_drawer.dart';
//استدعاء ملف ايقونة القائمة الجانبية


class AiAssistantScreen extends StatelessWidget {
  const AiAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'المساعد الذكي',
          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

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
                ),
                _buildChatBubble(
                  text: 'أين أجد ملزمة جودة البرمجيات؟',
                  isAi: false,
                ),
                _buildChatBubble(
                  text: 'ملزمة جودة البرمجيات موجودة في قسم: السنة الثالثة ⬅️ الترم الأول. هل تريدني أن أنقلك إليها مباشرة؟',
                  isAi: true,
                ),
              ],
            ),
          ),
          // شريط كتابة الرسالة في الأسفل
          _buildInputField(),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }

  // دالة مساعدة لبناء فقاعة المحادثة الذكية
  Widget _buildChatBubble({required String text, required bool isAi}) {
    return Align(
      // محاذاة لليمين للذكاء الاصطناعي، ولليسار للطالب
      alignment: isAi ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 280), // أقصى عرض للفقاعة
        decoration: BoxDecoration(
          color: isAi ? Colors.grey.shade100 : const Color(0xFF2E7D32),
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
            color: isAi ? Colors.black87 : Colors.white,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء حقل إدخال النص
  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              decoration: InputDecoration(
                hintText: 'اسأل عن أي مادة أو ملزمة...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
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
                // سيتم برمجة كود الإرسال للـ API مستقبلاً هنا
                print('تم الضغط على زر الإرسال');
              },
            ),
          ),
        ],
      ),
    );
  }
}