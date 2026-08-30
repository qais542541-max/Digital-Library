import 'package:flutter/material.dart';

class StepExternalInfo extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController institutionController;
  final TextEditingController jobTitleController;
  final String? selectedGender;
  final Function(String?) onGenderChanged;

  const StepExternalInfo({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.institutionController,
    required this.jobTitleController,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_pin, color: Colors.blue, size: 28),
              const SizedBox(width: 10),
              Text('بيانات الحساب الخارجي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700, fontFamily: 'Cairo')),
            ],
          ),
          const SizedBox(height: 8),
          Text('يرجى إدخال بياناتك الشخصية لإنشاء حساب في المكتبة الرقمية.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontFamily: 'Cairo')),
          const SizedBox(height: 25),

          _buildTextField('الاسم الكامل', 'أدخل اسمك الكامل', Icons.person, fullNameController, isDarkMode),
          const SizedBox(height: 15),

          _buildTextField('البريد الإلكتروني', 'أدخل بريدك الإلكتروني', Icons.email, emailController, isDarkMode, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 15),

          _buildTextField('رقم الهاتف', 'أدخل رقم هاتفك', Icons.phone, phoneController, isDarkMode, keyboardType: TextInputType.phone),
          const SizedBox(height: 15),

          // حقل الجنس (Dropdown)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('  الجنس', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('ذكر', style: TextStyle(fontFamily: 'Cairo'))),
                  DropdownMenuItem(value: 'female', child: Text('أنثى', style: TextStyle(fontFamily: 'Cairo'))),
                ],
                onChanged: onGenderChanged,
                decoration: InputDecoration(
                  hintText: 'اختر الجنس',
                  hintStyle: const TextStyle(fontFamily: 'Cairo'),
                  prefixIcon: const Icon(Icons.wc, color: Colors.grey),
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          _buildTextField('المؤسسة/الجهة', 'أدخل اسم المؤسسة أو الجهة التي تعمل بها', Icons.corporate_fare, institutionController, isDarkMode),
          const SizedBox(height: 15),

          _buildTextField('المسمى الوظيفي', 'أدخل المسمى الوظيفي', Icons.work, jobTitleController, isDarkMode),

          // مسافة إضافية في الأسفل لكي لا يغطي الزر على الحقول
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller, bool isDarkMode, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('  $label', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Cairo'),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontFamily: 'Cairo'),
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.blue, width: 2)),
          ),
        ),
      ],
    );
  }
}