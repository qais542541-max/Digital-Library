import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
                      ? 'change_password_screen.title_step_1'.tr()
                      : (step == 2 ? 'change_password_screen.title_step_2'.tr() : 'change_password_screen.title_step_3'.tr()),
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
                        labelText: 'change_password_screen.current_password'.tr(),
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
                        labelText: 'change_password_screen.new_password'.tr(),
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
                        child: Text('change_password_screen.forgot_password'.tr(), style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                  if (step == 2) ...[
                    Text(
                      'change_password_screen.verification_code_sent'.tr(),
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
                    Text('change_password_screen.enter_and_confirm_new_password'.tr(), style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: newPassController,
                      obscureText: obscureNew,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
                      decoration: InputDecoration(
                        labelText: 'change_password_screen.new_password'.tr(),
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
                        labelText: 'change_password_screen.confirm_password'.tr(),
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
                child: Text('change_password_screen.cancel'.tr(), style: const TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (step == 1 || step == 3) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('change_password_screen.password_updated_successfully'.tr()), backgroundColor: primaryGreen),
                    );
                  } else if (step == 2) {
                    if (codeController.text.isNotEmpty) {
                      setStateDialog(() => step = 3);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
                child: Text(step == 2 ? 'change_password_screen.verify'.tr() : 'change_password_screen.save'.tr(), style: const TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}
