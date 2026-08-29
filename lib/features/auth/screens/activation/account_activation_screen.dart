import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../steps/step_role_selection.dart';
import '../steps/step_credentials.dart';
import '../steps/step_verification.dart';

class AccountActivationScreen extends StatefulWidget {
  const AccountActivationScreen({super.key});

  @override
  State<AccountActivationScreen> createState() => _AccountActivationScreenState();
}

class _AccountActivationScreenState extends State<AccountActivationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // البيانات التي سيتم تجميعها من الخطوات
  String _selectedRole = 'student';
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تفعيل الحساب بنجاح!', style: TextStyle(fontFamily: 'Cairo'))),
      );
      Navigator.pop(context);
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
                  StepRoleSelection(
                    selectedRole: _selectedRole,
                    idController: _idController,
                    onRoleChanged: (role) => setState(() => _selectedRole = role),
                  ),
                  StepCredentials(
                    selectedRole: _selectedRole,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                  ),
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
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
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