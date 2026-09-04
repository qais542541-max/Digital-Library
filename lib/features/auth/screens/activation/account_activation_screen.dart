import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../steps/step_role_selection.dart';
import '../steps/step_credentials.dart';
import '../steps/step_verification.dart';
import '../steps/step_external_info.dart'; // استدعاء الشاشة الجديدة للزائر

class AccountActivationScreen extends StatefulWidget {
  const AccountActivationScreen({super.key});

  @override
  State<AccountActivationScreen> createState() => _AccountActivationScreenState();
}

class _AccountActivationScreenState extends State<AccountActivationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // حساب عدد الخطوات ديناميكياً (3 للموظف/الطالب، 4 للزائر)
  int get _totalSteps => _selectedRole == 'external' ? 4 : 3;

  String _selectedRole = 'student';

  // متحكمات البيانات المشتركة
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // متحكمات بيانات الزائر (مطابقة للموقع)
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  String? _selectedGender;

  bool _isLoading = false;
  Map<String, dynamic>? _memberData; // تخزين بيانات العضو المستلمة من السيرفر

  void _showUserDataDialog(Map<String, dynamic> userData) {
    setState(() => _memberData = userData); // حفظ البيانات للاستخدام لاحقاً
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        title: const Text(
          'تأكيد البيانات',
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.person, size: 40, color: primaryGreen),
            ),
            const SizedBox(height: 20),
            _buildDataRow('الاسم:', userData['name'] ?? 'غير متوفر', isDarkMode),
            _buildDataRow('الرقم:', userData['member_id'] ?? _idController.text, isDarkMode),
            _buildDataRow('القسم:', userData['department'] ?? 'العام', isDarkMode),
            _buildDataRow('النوع:', _selectedRole == 'student' ? 'طالب' : 'مدرس', isDarkMode),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo', color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // إغلاق النافذة
              _moveToNextStep(); // الانتقال للخطوة التالية
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('متابعة', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', color: Colors.grey.shade600, fontSize: 14)),
          Text(value, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }

  void _moveToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  Future<void> _sendVerification() async {
    setState(() => _isLoading = true);
    try {
      String apiUrl = kIsWeb
          ? 'http://localhost/lib_book2/api/send_verification.php'
          : 'http://192.168.1.102/lib_book2/api/send_verification.php';

      // تجهيز البيانات بناءً على الدور
      Map<String, dynamic> payload;
      if (_selectedRole == 'external') {
        payload = {
          "phone": _phoneController.text,
          "email": _emailController.text,
          "verification_method": "email",
          "member_id": 0,
          "first_name": _fullNameController.text.split(' ').first,
          "last_name": _fullNameController.text.split(' ').length > 1 ? _fullNameController.text.split(' ').last : "",
          "full_name": _fullNameController.text,
          "member_type": _selectedRole,
          "gender": _selectedGender ?? "male",
          "member_number": "",
          "institution": _institutionController.text,
          "job_title": _jobTitleController.text,
          "username": _usernameController.text,
          "password": _passwordController.text,
        };
      } else {
        payload = {
          "phone": _memberData?['phone'] ?? "77",
          "email": _memberData?['email'] ?? "a1^@g.com",
          "verification_method": "email",
          "member_id": int.tryParse(_memberData?['id']?.toString() ?? "0") ?? 0,
          "first_name": _memberData?['name']?.toString().split(' ').first ?? "",
          "last_name": "",
          "full_name": _memberData?['name'] ?? "",
          "member_type": _selectedRole,
          "gender": _memberData?['gender'] ?? "male",
          "member_number": _idController.text,
          "institution": "",
          "job_title": "",
          "username": _usernameController.text,
          "password": _passwordController.text,
        };
      }

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          // 👇 إظهار الكود في الشاشة لتسهيل التجربة للمطور
          if (responseData['debug_otp'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('للتجربة، كود التحقق هو: ${responseData['debug_otp']}', style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: Colors.blueAccent,
                duration: const Duration(seconds: 15), // إبقاء الرسالة لفترة أطول لتتمكن من حفظه
              ),
            );
          }
          _moveToNextStep(); // الانتقال لخطوة إدخال الـ OTP
        } else {
          throw Exception(responseData['message'] ?? 'فشل في إرسال الرمز');
        }
      } else {
        throw Exception('فشل الاتصال بالسيرفر: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال رمز التحقق', style: TextStyle(fontFamily: 'Cairo'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. تحديد الرابط الصحيح (تأكد من IP جهازك 102)
      String apiUrl = kIsWeb
          ? 'http://localhost/lib_book2/api/verify_otp.php'
          : 'http://192.168.1.102/lib_book2/api/verify_otp.php'; // تم التغيير إلى api/

      // 2. تجهيز البيانات للإرسال بصيغة JSON
      final payload = {
        "email": _selectedRole == 'external' ? _emailController.text : (_memberData?['email'] ?? ''),
        "otp": _otpController.text.trim(),
      };

      // 3. طباعة مساعدة للمطور لمعرفة ما يتم إرساله
      debugPrint("Sending to API: $apiUrl");
      debugPrint("Payload: $payload");

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': '*/*', // تعديل الهيدر ليقبل أي نوع
          'Content-Type': 'application/json',
          'User-Agent': 'Mozilla/5.0', // لتجنب رفض بعض السيرفرات للطلبات من التطبيقات
        },
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 15)); // زيادة وقت الانتظار قليلاً

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'تم تفعيل الحساب بنجاح! يمكنك الآن تسجيل الدخول.', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
          );
          Navigator.pop(context); // العودة لتسجيل الدخول
        } else {
          throw Exception(responseData['message'] ?? 'رمز التحقق غير صحيح');
        }
      } else {
        throw Exception('فشل الاتصال بالسيرفر. رمز الخطأ: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'.replaceAll('Exception: ', ''), style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _nextStep() async {
    // 1. التحقق من الهوية (الخطوة الأولى للأكاديميين)
    if (_currentStep == 0 && _selectedRole != 'external') {
      if (_idController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال الرقم الأكاديمي/الوظيفي', style: TextStyle(fontFamily: 'Cairo'))),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        String apiUrl = kIsWeb
            ? 'http://localhost/lib_book2/check_member.php'
            : 'http://192.168.1.102/lib_book2/check_member.php'; // تم التغيير إلى api/

        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.headers.addAll({'Accept': 'application/json'});
        request.fields['member_id'] = _idController.text.trim();
        request.fields['member_type'] = _selectedRole;

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          // 👇 التعديل هنا: نتحقق من responseData['success'] == true كما يرسلها السيرفر
          if (responseData['success'] == true && responseData['data'] != null) {
            _showUserDataDialog(responseData['data']);
          } else {
            throw Exception(responseData['message'] ?? 'البيانات غير صحيحة');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('الرقم غير مسجل في النظام. يرجى التأكد من البيانات.', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e', style: const TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.redAccent),
        );
      } finally {
        setState(() => _isLoading = false);
      }
      return;
    }

    // 2. إرسال رمز التحقق
    if (_currentStep == _totalSteps - 2) {
      if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يرجى إدخال بيانات الدخول كاملة', style: TextStyle(fontFamily: 'Cairo'))),
        );
        return;
      }
      await _sendVerification();
      return;
    }

    // 3. التحقق من الـ OTP (الخطوة الأخيرة)
    if (_currentStep == _totalSteps - 1) {
      await _verifyOTP();
      return;
    }

    // التنقل العادي بين الخطوات
    if (_currentStep < _totalSteps - 1) {
      _moveToNextStep();
    }
  }
  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: isDarkMode ? Colors.white : Colors.black87),
            onPressed: _previousStep,
          ),
          title: Text(
            _selectedRole == 'external' ? 'إنشاء حساب زائر' : 'تفعيل الحساب الأكاديمي',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildCustomProgressBar(primaryGreen, isDarkMode),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // الخطوة 1: اختيار الدور
                  StepRoleSelection(
                    selectedRole: _selectedRole,
                    idController: _idController,
                    onRoleChanged: (role) {
                      setState(() {
                        _selectedRole = role;
                        // إذا رجع المستخدم من خطوة متقدمة وغير دوره، أعده للخطوة الأولى
                        if (_currentStep > 0) {
                          _currentStep = 0;
                          _pageController.jumpToPage(0);
                        }
                      });
                    },
                  ),

                  // الخطوة 2: تختلف حسب الدور
                  if (_selectedRole == 'external')
                  // للزائر: إدخال البيانات الشخصية أولاً
                    StepExternalInfo(
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      institutionController: _institutionController,
                      jobTitleController: _jobTitleController,
                      selectedGender: _selectedGender,
                      onGenderChanged: (val) => setState(() => _selectedGender = val),
                    ),

                  // الخطوة 2 أو 3: بيانات الدخول (حسب الدور)
                  StepCredentials(
                    selectedRole: _selectedRole,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                  ),

                  // الخطوة الأخيرة: التحقق
                  StepVerification(
                    otpController: _otpController,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomControls(primaryGreen, isDarkMode),
      ),
    );
  }

  Widget _buildCustomProgressBar(Color primaryGreen, bool isDarkMode) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < _totalSteps; i++) {
      bool isActive = i <= _currentStep;

      rowChildren.add(
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: isActive ? primaryGreen : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            shape: BoxShape.circle,
            boxShadow: isActive ? [BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))] : [],
          ),
          child: Center(
            child: i < _currentStep
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : Text('${i + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Cairo')),
          ),
        ),
      );

      if (i < _totalSteps - 1) {
        rowChildren.add(
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: i < _currentStep ? primaryGreen : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ),
    );
  }

  Widget _buildBottomControls(Color primaryGreen, bool isDarkMode) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: bottomPadding > 0 ? bottomPadding : 24.0,
        top: 10.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10))
          ],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  disabledBackgroundColor: primaryGreen.withOpacity(0.6),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        _currentStep == _totalSteps - 1 ? 'تأكيد وإنهاء' : 'متابعة',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}