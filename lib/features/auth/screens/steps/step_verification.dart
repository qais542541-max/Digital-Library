import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepVerification extends StatelessWidget {
  final TextEditingController otpController;

  const StepVerification({super.key, required this.otpController});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(color: primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.mark_email_read_outlined, size: 50, color: primaryGreen),
          ),
          const SizedBox(height: 30),
          Text('رمز التحقق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87, fontFamily: 'Cairo')),
          const SizedBox(height: 10),
          Text(
            'لقد قمنا بإرسال رمز تحقق مكون من 6 أرقام إلى بريدك الإلكتروني المسجل لدينا.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontFamily: 'Cairo', height: 1.6),
          ),
          const SizedBox(height: 40),

          // تصميم حقل OTP عصري
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 32, letterSpacing: 20, fontWeight: FontWeight.bold),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: "", // إخفاء عداد الأحرف
                border: InputBorder.none,
                hintText: '------',
                hintStyle: TextStyle(letterSpacing: 20, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 30),

          TextButton(
            onPressed: () {},
            child: const Text('لم تستلم الرمز؟ أعد الإرسال', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}