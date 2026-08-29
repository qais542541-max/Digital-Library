import 'package:flutter/material.dart';

class StepRoleSelection extends StatelessWidget {
  final String selectedRole;
  final TextEditingController idController;
  final Function(String) onRoleChanged;

  const StepRoleSelection({
    super.key,
    required this.selectedRole,
    required this.idController,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حدد هويتك الأكاديمية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
          const SizedBox(height: 8),
          Text('اختر نوع الحساب الذي يتطابق مع بياناتك في الكلية', style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontFamily: 'Cairo')),
          const SizedBox(height: 30),

          // بطاقات الاختيار
          Row(
            children: [
              Expanded(child: _buildRoleCard('student', 'طالب', Icons.school, isDarkMode)),
              const SizedBox(width: 15),
              Expanded(child: _buildRoleCard('teacher', 'مدرس', Icons.workspace_premium, isDarkMode)),
              const SizedBox(width: 15),
              Expanded(child: _buildRoleCard('external', 'زائر', Icons.person_outline, isDarkMode)),
            ],
          ),
          const SizedBox(height: 40),

          // حقل الإدخال المتحرك
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedRole != 'external'
                ? Column(
              key: const ValueKey('internal_user'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedRole == 'student' ? 'الرقم الأكاديمي' : 'الرقم الوظيفي', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
                const SizedBox(height: 10),
                TextField(
                  controller: idController,
                  style: const TextStyle(fontFamily: 'Cairo'),
                  decoration: InputDecoration(
                    hintText: selectedRole == 'student' ? 'مثال: STU-2026-0001' : 'مثال: TCH-001',
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF2E7D32)),
                    filled: true,
                    fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
                  ),
                ),
              ],
            )
                : Container(
              key: const ValueKey('external_user'),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orange.withOpacity(0.3))),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 15),
                  Expanded(child: Text('كعضو زائر، سيُطلب منك إدخال بياناتك بالكامل في الخطوة التالية لإنشاء ملفك الشخصي.', style: TextStyle(color: isDarkMode ? Colors.orange.shade300 : Colors.orange.shade800, fontFamily: 'Cairo', fontSize: 13, height: 1.5))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(String roleValue, String title, IconData icon, bool isDarkMode) {
    bool isSelected = selectedRole == roleValue;
    const Color primaryGreen = Color(0xFF2E7D32);

    return GestureDetector(
      onTap: () => onRoleChanged(roleValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withOpacity(0.1) : (isDarkMode ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryGreen : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300), width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: isSelected ? primaryGreen : Colors.grey),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: isSelected ? primaryGreen : (isDarkMode ? Colors.white : Colors.black87))),
          ],
        ),
      ),
    );
  }
}