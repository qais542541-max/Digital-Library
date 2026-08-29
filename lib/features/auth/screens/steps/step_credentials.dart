import 'package:flutter/material.dart';

class StepCredentials extends StatefulWidget {
  final String selectedRole;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const StepCredentials({
    super.key,
    required this.selectedRole,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  State<StepCredentials> createState() => _StepCredentialsState();
}

class _StepCredentialsState extends State<StepCredentials> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  bool _agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedRole != 'external') ...[
            Text('تأكيد الهوية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
            const SizedBox(height: 15),

            // بطاقة الهوية الأنيقة
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primaryGreen, primaryGreen.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.person, color: primaryGreen, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('عمار العقبي', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                        Text(widget.selectedRole == 'student' ? 'أمن المعلومات • STU-2026-0001' : 'مدرس • TCH-001', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontFamily: 'Cairo')),
                      ],
                    ),
                  ),
                  const Icon(Icons.verified, color: Colors.white, size: 28),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],

          Text('بيانات الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
          const SizedBox(height: 15),

          _buildTextField('اسم مستخدم جديد', Icons.alternate_email, widget.usernameController, false, isDarkMode),
          const SizedBox(height: 15),

          _buildTextField('كلمة المرور', Icons.lock_outline, widget.passwordController, _isObscure1, isDarkMode,
              suffix: IconButton(icon: Icon(_isObscure1 ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _isObscure1 = !_isObscure1))),
          const SizedBox(height: 15),

          _buildTextField('تأكيد كلمة المرور', Icons.lock_outline, null, _isObscure2, isDarkMode,
              suffix: IconButton(icon: Icon(_isObscure2 ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _isObscure2 = !_isObscure2))),

          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: _agreeTerms,
                activeColor: primaryGreen,
                onChanged: (val) => setState(() => _agreeTerms = val!),
              ),
              Expanded(
                child: Text.rich(TextSpan(
                  text: 'أوافق على ', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo', fontSize: 13),
                  children: const [TextSpan(text: 'الشروط والأحكام ', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)), TextSpan(text: 'الخاصة بالمكتبة.')],
                )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController? controller, bool obscure, bool isDarkMode, {Widget? suffix}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffix,
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
      ),
    );
  }
}