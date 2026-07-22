import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfTitle;
  final String pdfUrl;

  const PdfViewerScreen({
    super.key,
    required this.pdfTitle,
    required this.pdfUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)), // لون سهم الرجوع
        title: Text(
          pdfTitle,
          style: const TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      // هنا يحدث السحر: هذه الأداة تتكفل بجلب الـ PDF من الرابط وعرضه
      body: SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false, // لإخفاء شريط التمرير المزعج وجعل الواجهة نظيفة
      ),
    );
  }
}