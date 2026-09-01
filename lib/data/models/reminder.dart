enum ReminderType { medicine, water, other }

class Reminder {
  final String id;
  final String title;
  final ReminderType type;
  final String time; // e.g. "9:00 AM"

  const Reminder({
    required this.id,
    required this.title,
    required this.type,
    required this.time,
  });
}