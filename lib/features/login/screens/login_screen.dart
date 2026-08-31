import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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

  void _performLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال اسم المستخدم وكلمة المرور', style: TextStyle(fontFamily: 'Cairo'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String apiUrl = kIsWeb
          ? 'http://localhost/lib_book2/api/login.php'
          : 'http://192.168.1.100/lib_book2/api/login.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'ajax_login': '1',
          'username': _usernameController.text,
          'password': _passwordController.text,
          'remember': '1',
        },
      );

      if (response.statusCode == 200) {
        // فك تشفير الرد
        dynamic responseData;
        try {
          responseData = json.decode(response.body);
        } catch (e) {
          // إذا لم يكن الرد JSON، قد يكون نصاً عادياً مثل "1" أو "success"
          responseData = response.body.trim();
        }

        bool isSuccess = false;
        String? roleStr;
        String? nameStr;

        if (responseData is Map) {
          // التحقق من حالة النجاح في الـ JSON
          isSuccess = (responseData['status'] == 'success' || 
                       responseData['success'] == true || 
                       responseData['status'] == '1' ||
                       responseData['status'] == 1) &&
                      (responseData['error'] == null || responseData['error'] == false);
          
          roleStr = responseData['role']?.toString();
          nameStr = responseData['user']?['name'] ?? responseData['name'];
        } else if (responseData == '1' || responseData == 'success') {
          isSuccess = true;
        }

        if (isSuccess) {
          if (!mounted) return;
          
          UserRole role = UserRole.student;
          String receivedRole = roleStr?.toLowerCase() ?? '';
          if (receivedRole == 'teacher') role = UserRole.teacher;
          else if (receivedRole == 'employee') role = UserRole.employee;

          // حفظ الجلسة
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userName', nameStr ?? _usernameController.text);
          await prefs.setString('userRole', receivedRole);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                role: role,
                userName: nameStr ?? _usernameController.text,
              ),
            ),
          );
        } else {
          if (!mounted) return;
          // عرض رسالة خطأ دقيقة بناءً على رد السيرفر
          String errorMsg = 'اسم المستخدم أو كلمة المرور غير صحيحة';
          if (responseData is Map && responseData['message'] != null) {
            errorMsg = responseData['message'];
          } else if (responseData is Map && responseData['error'] != null && responseData['error'] is String) {
            errorMsg = responseData['error'];
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg, style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في السيرفر: ${response.statusCode}', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ في الاتصال: $e', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _loginAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(role: UserRole.guest, userName: 'ضيف'),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    const String phoneNumber = "+967774947722";
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح تطبيق واتساب', style: TextStyle(fontFamily: 'Cairo'))),
        );
      }
    }
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              const Icon(Icons.headset_mic, color: Colors.blue, size: 40),
              const SizedBox(height: 10),
              Text('الدعم الفني', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSupportRow(Icons.phone, 'الهاتف: 0123456789', Colors.blue, isDarkMode),
              const Divider(height: 20),
              _buildSupportRow(Icons.email, 'support@modern-tech.edu', Colors.blue, isDarkMode),
              const Divider(height: 20),
              _buildSupportRow(Icons.chat, 'واتساب: 0123456789', Colors.green, isDarkMode),
              const Divider(height: 20),
              _buildSupportRow(Icons.access_time, 'ساعات العمل: 8:00 ص - 4:00 م', Colors.orange, isDarkMode),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupportRow(IconData icon, String text, Color iconColor, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 15),
        Expanded(child: Text(text, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
        body: SafeArea(
          bottom: false, // السماح للخلفية بالامتداد بينما نتحكم بالأزرار بدقة
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Stack(
              children: [
                Container(
                  height: size.height * 0.40,
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
                Positioned(top: -50, right: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05))),
                Positioned(bottom: size.height * 0.60, left: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.1))),

                Column(
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20)]),
                      child: const Icon(Icons.local_library, size: 45, color: primaryGreen),
                    ),
                    const SizedBox(height: 10),
                    const Text('المكتبة الرقمية', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo')),
                    const Text('كلية المجتمع صنعاء', style: TextStyle(fontSize: 13, color: Colors.white70, fontFamily: 'Cairo')),

                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 24, right: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تسجيل الدخول', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
                          const SizedBox(height: 20),
                          _buildTextField(controller: _usernameController, label: 'اسم المستخدم أو البريد الإلكتروني', icon: Icons.person_outline, isDarkMode: isDarkMode),
                          const SizedBox(height: 15),
                          _buildTextField(controller: _passwordController, label: 'كلمة المرور', icon: Icons.lock_outline, isDarkMode: isDarkMode, isPassword: true),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: primaryGreen, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _performLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                  : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ليس لديك حساب أكاديمي؟', style: TextStyle(color: Colors.grey.shade600, fontFamily: 'Cairo', fontSize: 13)),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountActivationScreen())),
                          child: const Text('تفعيل الحساب', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 13)),
                        ),
                      ],
                    ),

                    TextButton.icon(
                      onPressed: _loginAsGuest,
                      icon: const Icon(Icons.person_outline, color: Colors.grey),
                      label: const Text('الدخول كضيف', style: TextStyle(color: Colors.grey, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      ),
                    ),

                    const SizedBox(height: 5),
                    const Divider(indent: 50, endIndent: 50),
                    const SizedBox(height: 10),

                    // إحاطة الأزرار السفلية بـ SafeArea مع مسافة أمان قوية لضمان ظهورها فوق شريط النظام
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildBottomActionItem(
                              icon: Icons.headset_mic,
                              label: 'الدعم الفني',
                              color: Colors.blue,
                              isDarkMode: isDarkMode,
                              onTap: _showSupportDialog,
                            ),
                            _buildBottomActionItem(
                              icon: Icons.admin_panel_settings,
                              label: 'المسؤولين',
                              color: Colors.blueGrey,
                              isDarkMode: isDarkMode,
                              onTap: () {},
                            ),
                            _buildBottomActionItem(
                              icon: Icons.chat_bubble_outline,
                              label: 'واتساب',
                              color: Colors.green,
                              isDarkMode: isDarkMode,
                              onTap: _openWhatsApp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionItem({required IconData icon, required String label, required Color color, required bool isDarkMode, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

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