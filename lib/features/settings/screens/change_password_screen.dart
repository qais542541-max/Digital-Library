import 'package:flutter/material.dart';

// دالة خارجية مستقلة لاستدعاء النافذة بسهولة
void showChangePasswordDialog(BuildContext context, bool isDarkMode) {
  showDialog(
    context: context,
    builder: (context) {
      int step = 1;

      final currentPassController = TextEditingController();
      final newPassController = TextEditingController();
      final confirmPassController = TextEditingController();
      final codeController = TextEditingController();

      bool obscureCurrent = true;
      bool obscureNew = true;
      bool obscureConfirm = true;

      const Color primaryGreen = Color(0xFF2E7D32);

      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                const Icon(Icons.lock_outline, color: primaryGreen),
                const SizedBox(width: 8),
                Text(
                  step == 1
                      ? 'تغيير كلمة المرور'
                      : (step == 2 ? 'إدخال رمز التحقق' : 'كلمة المرور الجديدة'),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (step == 1) ...[
                    TextField(
                      controller: currentPassController,
                      obscureText: obscureCurrent,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الحالية',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(obscureCurrent ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setStateDialog(() => obscureCurrent = !obscureCurrent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newPassController,
                      obscureText: obscureNew,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(obscureNew ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                          onPressed: () => setStateDialog(() => obscureNew = !obscureNew),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => setStateDialog(() => step = 2),
                        child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                  if (step == 2) ...[
                    Text(
                      'تم إرسال رمز تحقق مكون من 4 أرقام إلى بريدك الإلكتروني.',
                      style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: codeController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87, letterSpacing: 8, fontSize: 18),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '----',
                        hintStyle: const TextStyle(letterSpacing: 8),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                  if (step == 3) ...[
                    const Text('الرجاء إدخال كلمة المرور الجديدة وتأكيدها.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPassController,
                      obscureText: obscureNew,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور الجديدة',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmPassController,
                      obscureText: obscureConfirm,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (step == 1 || step == 3) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح'), backgroundColor: primaryGreen),
                    );
                  } else if (step == 2) {
                    if (codeController.text.isNotEmpty) {
                      setStateDialog(() => step = 3);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: Text(step == 2 ? 'تحقق' : 'حفظ', style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}