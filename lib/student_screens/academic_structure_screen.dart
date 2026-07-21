import 'package:flutter/material.dart';
import '../core/widgets/unified_item_card.dart';
import 'year_details_screen.dart'; // سنقوم بإنشاء هذه الشاشة في الخطوة التالية

class AcademicStructureScreen extends StatelessWidget {
  const AcademicStructureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للسنوات الدراسية (سيتم جلبها مستقبلاً من الـ API)
    final List<String> years = ['السنة الأولى', 'السنة الثانية', 'السنة الثالثة'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'الهيكلية الأكاديمية',
          style: TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: years.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0), // مسافة بين الحاويات
            child: UnifiedItemCard(
              title: years[index],
              subtitle: 'تخصص برمجة حاسوب', // اسم التخصص يمكن أن يكون ديناميكياً لاحقاً
              icon: Icons.school,
              isGridView: false,
              onTap: () {
                // الانتقال إلى شاشة الأترام وتمرير اسم السنة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => YearDetailsScreen(yearName: years[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}