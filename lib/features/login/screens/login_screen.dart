import 'package:flutter/material.dart';
import 'package:digital_library/features/layout/screens/main_screen.dart';
import 'package:digital_library/features/auth/screens/activation/account_activation_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  bool _isLoading = false;

  void _performLogin() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المستخدم وكلمة المرور', style: TextStyle(fontFamily: 'Cairo'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(role: UserRole.student, userName: _usernameController.text),
        ),
      );
    });
  }

  void _loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(role: UserRole.guest, userName: 'ضيف'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. القسم العلوي (الخلفية المنحنية والشعار)
            Stack(
              children: [
                Container(
                  height: size.height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryGreen.withOpacity(0.9), primaryGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                ),
                // دوائر تجميلية في الخلفية
                Positioned(
                  top: -50, right: -50,
                  child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05)),
                ),
                Positioned(
                  bottom: -20, left: -20,
                  child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1)),
                ),
                // الشعار والنصوص
                Positioned(
                  top: size.height * 0.12,
                  left: 0, right: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
                        child: const Icon(Icons.local_library, size: 50, color: primaryGreen),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'المكتبة الرقمية',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                      ),
                      Text(
                        'كلية المجتمع صنعاء',
                        style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // 2. القسم السفلي (بطاقة تسجيل الدخول الطافية)
            Transform.translate(
              offset: const Offset(0, -30), // رفع البطاقة لتتداخل مع الخلفية الخضراء
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('تسجيل الدخول', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
                    const SizedBox(height: 25),

                    // حقل اسم المستخدم
                    _buildTextField(
                      controller: _usernameController,
                      label: 'اسم المستخدم أو البريد الإلكتروني',
                      icon: Icons.person_outline,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 20),

                    // حقل كلمة المرور
                    _buildTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      icon: Icons.lock_outline,
                      isDarkMode: isDarkMode,
                      isPassword: true,
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: primaryGreen, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // زر تسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _performLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0, // أزلنا الظل لأن البطاقة نفسها تمتلك ظلاً
                        ),
                        child: _isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                            : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. خيارات أسفل البطاقة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ليس لديك حساب أكاديمي؟', style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Cairo', fontSize: 13)),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountActivationScreen()));
                  },
                  child: const Text('تفعيل الحساب', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // زر التصفح كضيف بتصميم لطيف
            OutlinedButton.icon(
              onPressed: _loginAsGuest,
              icon: const Icon(Icons.explore_outlined, size: 18, color: Colors.grey),
              label: const Text('تصفح المكتبة كزائر', style: TextStyle(color: Colors.grey, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لرسم حقول الإدخال بشكل متناسق جداً مع باقي التطبيق
  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, required bool isDarkMode, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      style: const TextStyle(fontFamily: 'Cairo'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.grey.shade500),
        suffixIcon: isPassword
            ? IconButton(icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade500), onPressed: () => setState(() => _isObscure = !_isObscure))
            : null,
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}