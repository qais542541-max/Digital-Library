import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/settings_provider.dart';
import '../../layout/screens/main_screen.dart'; // 👈 استدعاء ملف الصلاحيات (تأكد من المسار لديك)

class ProfileScreen extends StatefulWidget {
  final UserRole role; // 👈 إضافة متغير الصلاحية لاستقبال دور المستخدم

  const ProfileScreen({super.key, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // متحكمات النصوص (سيتم تعبئتها لاحقاً من قاعدة البيانات حسب المستخدم)
  final TextEditingController _nameController = TextEditingController(text: 'عمار العقبي');
  final TextEditingController _emailController = TextEditingController(text: 'ammar@scc.edu.ye');
  final TextEditingController _phoneController = TextEditingController(text: '+967 77X XXX XXX');

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("خطأ في اختيار الصورة: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF2E7D32);
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    final isArabic = settings.languageCode == 'ar';

    // 👇 تحديد مسمى الرقم الثابت حسب الصلاحية
    final String idLabel = widget.role == UserRole.student
        ? (isArabic ? 'الرقم الجامعي' : 'Student ID')
        : (isArabic ? 'الرقم الوظيفي' : 'Employee ID');

    final String idValue = widget.role == UserRole.student ? '20241050' : '900125';

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(isArabic ? 'الملف الشخصي' : 'Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 1. صورة المستخدم
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryGreen, width: 3),
                      color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                      image: _imageFile != null
                          ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                          : const DecorationImage(
                        image: AssetImage('assets/images/default_avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. البيانات الأكاديمية / الوظيفية (تتغير حسب الدور)
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  // هذا الحقل يظهر للجميع (لكن مسماه يتغير: رقم جامعي أو وظيفي)
                  _buildReadOnlyInfo(Icons.badge, idLabel, idValue, isDarkMode),

                  // 👇 هذه الحقول تظهر للطالب فــــــــــقــــــــــط 👇
                  if (widget.role == UserRole.student) ...[
                    const Divider(height: 20),
                    _buildReadOnlyInfo(Icons.computer, isArabic ? 'التخصص' : 'Major', isArabic ? 'برمجة حاسوب' : 'Computer Programming', isDarkMode),
                    const Divider(height: 20),
                    _buildDropdownRow(
                      icon: Icons.school,
                      title: isArabic ? 'المستوى الدراسي' : 'Academic Year',
                      currentValue: settings.academicYear,
                      items: ['السنة الأولى', 'السنة الثانية', 'السنة الثالثة', 'السنة الرابعة'],
                      onChanged: (val) => settings.changeAcademicYear(val!),
                      isDarkMode: isDarkMode,
                    ),
                    const Divider(height: 20),
                    _buildDropdownRow(
                      icon: Icons.calendar_month,
                      title: isArabic ? 'الترم الحالي' : 'Current Term',
                      currentValue: settings.academicTermIndex == 0 ? 'الترم الأول' : 'الترم الثاني',
                      items: ['الترم الأول', 'الترم الثاني'],
                      onChanged: (val) {
                        int index = val == 'الترم الأول' ? 0 : 1;
                        settings.changeAcademicTerm(index);
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 3. البيانات الشخصية المتاحة للجميع للتعديل
            _buildEditableField(isArabic ? 'الاسم الكامل' : 'Full Name', Icons.person_outline, _nameController, isDarkMode),
            const SizedBox(height: 16),
            _buildEditableField(isArabic ? 'البريد الإلكتروني' : 'Email', Icons.email_outlined, _emailController, isDarkMode, isEmail: true),
            const SizedBox(height: 16),
            _buildEditableField(isArabic ? 'رقم الهاتف' : 'Phone Number', Icons.phone_outlined, _phoneController, isDarkMode, isPhone: true),
            const SizedBox(height: 40),

            // 4. زر الحفظ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isArabic ? 'تم تحديث بياناتك بنجاح' : 'Profile updated successfully'),
                      backgroundColor: primaryGreen,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isArabic ? 'حفظ التغييرات' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyInfo(IconData icon, String title, String value, bool isDarkMode) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 22),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownRow({required IconData icon, required String title, required String currentValue, required List<String> items, required Function(String?) onChanged, required bool isDarkMode}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade500, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  isExpanded: true,
                  value: currentValue,
                  dropdownColor: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontFamily: 'Cairo',
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E7D32)),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, IconData icon, TextEditingController controller, bool isDarkMode, {bool isEmail = false, bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
      ),
    );
  }
}