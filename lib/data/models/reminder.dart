import 'package:flutter/material.dart';

class Reminder {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  const Reminder({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}