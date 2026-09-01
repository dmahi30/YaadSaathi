import '../models/reminder.dart';

final List<Reminder> fakeReminders = [
  Reminder(
    id: 'r1',
    title: 'Take your medicine',
    type: ReminderType.medicine,
    time: '9:00 AM',
  ),
  Reminder(
    id: 'r2',
    title: 'Drink a glass of water',
    type: ReminderType.water,
    time: '11:00 AM',
  ),
];