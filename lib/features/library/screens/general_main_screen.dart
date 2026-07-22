import 'package:flutter/material.dart';
import '../../../core/widgets/unified_item_card.dart';
import '../../../core/widgets/custom_drawer.dart';

class GeneralMainScreen extends StatelessWidget {
  // متغيرات ديناميكية لجعل الشاشة صالحة للطالب والدكتور
  final String userName;
  final String userRole; // مثلاً: "طالب - المستوى الثالث" أو "عضو هيئة تدريس"

  const GeneralMainScreen({
    super.key,
    required this.userName,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد لون البطاقة بناءً على نوع المستخدم (أخضر للطالب، أزرق غامق مثلاً للدكتور)
    final bool isStudent = userRole.contains('طالب');
    final List<Color> cardColors = isStudent
        ? [const Color(0xFF2E7D32), const Color(0xFF4CAF50)] // أخضر للطالب
        : [const Color(0xFF1565C0), const Color(0xFF42A5F5)]; // أزرق للدكتور

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الرئيسية',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // البطاقة الترحيبية الديناميكية
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: cardColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: cardColors[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك، $userName', // الاسم يتغير تلقائياً
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  userRole, // الصفة تتغير تلقائياً
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // قسم الإعلانات العامة (يظهر للجميع)
          const Text(
            'أحدث الإعلانات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          UnifiedItemCard(
            title: 'تحديث نظام المكتبة',
            subtitle: 'تمت إضافة ميزة التنزيل للمقررات الدراسية',
            icon: Icons.campaign,
            isGridView: false,
            onTap: () {
              print('فتح الإعلان');
            },
          ),
          const SizedBox(height: 12),
          UnifiedItemCard(
            title: 'إشعار من عمادة الكلية',
            subtitle: 'موعد تسليم مشاريع التخرج للعام الحالي',
            icon: Icons.notifications_active,
            isGridView: false,
            onTap: () {
              print('فتح الإشعار');
            },
          ),
        ],
      ),
    );
  }
}