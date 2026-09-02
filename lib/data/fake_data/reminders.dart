import 'package:flutter/material.dart';
import '../models/reminder.dart';

class FakeReminderData {
  FakeReminderData._();

  static const List<Reminder> reminders = [
    Reminder(
      title: 'Medicine',
      time: '8:00 AM',
      icon: Icons.medication,
      color: Color(0xFFF3B6C4),
    ),
    Reminder(
      title: 'Water',
      time: '10:00 AM',
      icon: Icons.water_drop,
      color: Color(0xFFA8D0E6),
    ),
  ];
}