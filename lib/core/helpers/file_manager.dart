import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class FileManager {
  static final Dio _dio = Dio();

  // استخراج اسم الملف الصافي من الرابط (مثلاً: file_123.pdf)
  static String getFileNameFromPath(String filePath) {
    if (filePath.isEmpty) return 'unknown_file';
    return filePath.split('/').last;
  }

  // الحصول على المسار الآمن للحفظ داخل هاتف المستخدم
  static Future<String> getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  // التحقق مما إذا كان الملف قد تم تنزيله مسبقاً
  static Future<bool> isFileDownloaded(String fileName) async {
    final path = await getLocalFilePath(fileName);
    final file = File(path);
    return await file.exists();
  }

  // دالة التنزيل
  static Future<String?> downloadFile({
    required String url,
    required String fileName,
    required Function(int received, int total) onProgress,
  }) async {
    try {
      final savePath = await getLocalFilePath(fileName);
      await _dio.download(url, savePath, onReceiveProgress: onProgress);
      return savePath;
    } catch (e) {
      debugPrint('خطأ في تنزيل الملف: $e');
      return null;
    }
  }
}