import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum UploadRestriction {
  pdfOnly,
  youtubeLink,
  pdfAndImages,
  mixedContent, // 👈 نوع جديد يدعم النظري والعملي معاً
}

class SmartUploadBottomSheet extends StatefulWidget {
  final String categoryName;
  final UploadRestriction restriction;
  final Map<String, dynamic>? initialData;
  final bool isCourseMaterial; // 👈 1. إضافة متغير جديد لمعرفة هل الرفع لمقرر دراسي أم لا

  const SmartUploadBottomSheet({
    super.key,
    required this.categoryName,
    required this.restriction,
    this.initialData,
    this.isCourseMaterial = false, // القيمة الافتراضية مكتبة
  });

  @override
  State<SmartUploadBottomSheet> createState() => _SmartUploadBottomSheetState();
}

class _SmartUploadBottomSheetState extends State<SmartUploadBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descController;
  late TextEditingController _linkController;


  String? _selectedFileName;
  String? _selectedCoverImage;
  String _teachingMethod = 'theoretical'; // theoretical أو practical

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _authorController = TextEditingController(text: widget.initialData?['author'] ?? '');
    _descController = TextEditingController(text: widget.initialData?['description'] ?? '');
    _linkController = TextEditingController(text: widget.initialData?['link'] ?? '');

    _selectedFileName = widget.initialData?['fileName'];
    _selectedCoverImage = widget.initialData?['coverImage'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _pickFile() {
    setState(() {
      _selectedFileName = 'ملف_المحاضرة.pdf';
    });
  }

  void _pickCoverImage() {
    setState(() {
      _selectedCoverImage = 'غلاف_المادة.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const Color primaryGreen = Color(0xFF2E7D32);
    final bool isEditMode = widget.initialData != null;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              isEditMode
                  ? 'تعديل: ${widget.categoryName}'
                  : (widget.isCourseMaterial ? 'إضافة محتوى إلى المقرر' : 'رفع جديد إلى: ${widget.categoryName}'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : primaryGreen,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),

            // 1. العنوان (إلزامي للجميع)
            TextField(
              controller: _titleController,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: InputDecoration(
                labelText: widget.isCourseMaterial ? 'عنوان المحاضرة / الملزمة' : 'العنوان',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 15),

            // 2. حقل الأستاذ (يظهر فقط إذا كنا في المكتبة العامة، أما في المقرر فيمكن معرفة الأستاذ تلقائياً من تسجيل الدخول)
            if (!widget.isCourseMaterial) ...[
              TextField(
                controller: _authorController,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  labelText: widget.restriction == UploadRestriction.youtubeLink ? 'اسم المحاضر' : 'اسم المؤلف',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 15),
            ],

            // 3. الوصف أو الملاحظات (مهم للمقررات والمكتبة)
            TextField(
              controller: _descController,
              maxLines: 2,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: InputDecoration(
                labelText: 'ملاحظات أو وصف مختصر',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // 4. رفع الملف أو رابط الفيديو (حسب التقييد)
            if (widget.restriction == UploadRestriction.mixedContent) ...[
              Text('نوع المادة العلمية:', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: isDarkMode ? Colors.white : Colors.black87)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('نظري (ملف / صورة)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                      value: 'theoretical',
                      groupValue: _teachingMethod,
                      activeColor: primaryGreen,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) => setState(() => _teachingMethod = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('عملي (رابط فيديو)', style: TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                      value: 'practical',
                      groupValue: _teachingMethod,
                      activeColor: primaryGreen,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) => setState(() => _teachingMethod = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],

            // 👇 بناءً على اختيار الأستاذ، نظهر حقل الرابط أو حقل اختيار الملف:
            if (widget.restriction == UploadRestriction.youtubeLink || _teachingMethod == 'practical') ...[
              TextField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  labelText: 'رابط فيديو يوتيوب أو مسار خارجي',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.ondemand_video, color: Colors.red),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  // إظهار غلاف اختياري فقط للمكتبة وليس للمقررات السريعة
                  if (!widget.isCourseMaterial) ...[
                    Expanded(
                      child: InkWell(
                        onTap: _pickCoverImage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.image_outlined, size: 26, color: _selectedCoverImage != null ? primaryGreen : Colors.grey),
                              const SizedBox(height: 5),
                              Text(
                                _selectedCoverImage ?? 'الغلاف',
                                style: TextStyle(fontSize: 11, fontFamily: 'Cairo', color: _selectedCoverImage != null ? primaryGreen : Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],

                  // رفع الملف الأساسي (PDF)
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: _pickFile,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.picture_as_pdf_outlined, size: 26, color: _selectedFileName != null ? primaryGreen : Colors.grey),
                            const SizedBox(height: 5),
                            Text(
                              _selectedFileName ?? 'اختر ملف PDF للمحاضرة',
                              style: TextStyle(fontSize: 11, fontFamily: 'Cairo', color: _selectedFileName != null ? primaryGreen : Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isEditMode ? 'حفظ التعديلات' : 'نشر المحتوى',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Cairo'),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}