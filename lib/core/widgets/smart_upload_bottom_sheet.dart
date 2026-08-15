import 'package:flutter/material.dart';

// 👇 1. تعريف أنواع القيود المتاحة في التطبيق كله
enum UploadRestriction {
  pdfOnly,          // للمكتبة العامة والملازم
  youtubeLink,      // للمحاضرات
  pdfAndImages,     // للتكاليف والنماذج
}

class SmartUploadBottomSheet extends StatefulWidget {
  final String categoryName;
  final UploadRestriction restriction; // 👈 استقبال نوع التقييد
  final Map<String, dynamic>? initialData;

  const SmartUploadBottomSheet({
    super.key,
    required this.categoryName,
    required this.restriction,
    this.initialData,
  });

  @override
  State<SmartUploadBottomSheet> createState() => _SmartUploadBottomSheetState();
}

class _SmartUploadBottomSheetState extends State<SmartUploadBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData?['title'] ?? '');
    _linkController = TextEditingController(text: widget.initialData?['link'] ?? '');
    _selectedFileName = widget.initialData?['fileName'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _pickFile() {
    String allowedExtensions = '';
    if (widget.restriction == UploadRestriction.pdfOnly) {
      allowedExtensions = 'PDF فقط';
    } else if (widget.restriction == UploadRestriction.pdfAndImages) {
      allowedExtensions = 'PDF أو صور (JPG, PNG)';
    }

    print('فتح ملفات الهاتف... المسموح: $allowedExtensions');
    setState(() {
      _selectedFileName = 'ملف_تجريبي.pdf';
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
              isEditMode ? 'تعديل في ${widget.categoryName}' : 'رفع مورد جديد (${widget.categoryName})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : primaryGreen,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'عنوان المورد',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20),

            // 👇 2. تغيير الواجهة بناءً على التقييد
            if (widget.restriction == UploadRestriction.youtubeLink) ...[
              TextField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'رابط يوتيوب',
                  hintText: 'https://youtube.com/...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.ondemand_video, color: Colors.red),
                ),
              ),
            ] else ...[
              InkWell(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 40, color: primaryGreen),
                      const SizedBox(height: 10),
                      Text(
                        _selectedFileName ?? 'اضغط لاختيار ملف',
                        style: TextStyle(
                          color: _selectedFileName != null ? primaryGreen : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.restriction == UploadRestriction.pdfOnly
                            ? 'الصيغ المسموحة: PDF فقط'
                            : 'الصيغ المسموحة: PDF, JPG, PNG',
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
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
                  isEditMode ? 'حفظ التعديلات' : 'رفع المورد',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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