import 'package:flutter/material.dart';
class Subject {
  final int id;
  final String title;
  final String imageUrl; // مسار صورة أو أيقونة المقرر
  final IconData icon;

  Subject({
    required this.id,
    required this.title,
    this.imageUrl = 'assets/images/default_subject.png',
    required this.icon,
  });
}