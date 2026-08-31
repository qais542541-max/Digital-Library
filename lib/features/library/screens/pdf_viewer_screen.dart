import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String bookTitle;

  final bool isLocal;
  const PdfViewerScreen({super.key, required this.pdfUrl, required this.bookTitle, this.isLocal = false});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDarkMode = settings.isDarkMode;
    const Color primaryGreen = Color(0xFF2E7D32);

    return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.grey.shade50,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF2E7D32)), // لون سهم الرجوع
        title: Text(
          bookTitle,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // هنا يحدث السحر: هذه الأداة تتكفل بجلب الـ PDF من الرابط وعرضه
      body: isLocal
          ? SfPdfViewer.file(
        File(pdfUrl), // يحتاج import 'dart:io'; في الأعلى
        canShowScrollHead: false,
        canShowScrollStatus: false,
      )
          : SfPdfViewer.network(
        pdfUrl,
        canShowScrollHead: false,
        canShowScrollStatus: false,
      ),
    );
  }
}
