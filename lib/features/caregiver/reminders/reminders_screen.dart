import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CaregiverRemindersScreen extends StatefulWidget {
  const CaregiverRemindersScreen({
    super.key,
  });

  @override
  State<CaregiverRemindersScreen> createState() =>
      _CaregiverRemindersScreenState();
}

class _CaregiverRemindersScreenState
    extends State<CaregiverRemindersScreen> {
  int _selectedTab = 0;

  // Reminder records are created only from caregiver input.
  // No patient/user/demo data is hardcoded here.
  final List<_ReminderItem> _reminders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: _buildReminderList(),
            ),
            _buildAddReminderButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        8,
      ),
      child: Row(
        children: [
          _circleButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Reminders',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ),
          _circleButton(
            icon: Icons.volume_up_outlined,
            onTap: () {
              // TTS can be connected later.
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TABS
  // ---------------------------------------------------------------------------

  Widget _buildTabs() {
    const tabs = [
      'Today',
      'Upcoming',
      'Completed',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        6,
        18,
        8,
      ),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) {
              final isSelected = _selectedTab == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(
                      milliseconds: 180,
                    ),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreenLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.textMedium,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REMINDER LIST
  // ---------------------------------------------------------------------------

  Widget _buildReminderList() {
    final reminders = _filteredReminders();

    if (reminders.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          18,
          18,
          18,
          20,
        ),
        child: _buildEmptyState(),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        18,
        10,
        18,
        20,
      ),
      itemCount: reminders.length,
      separatorBuilder: (_, _) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final reminder = reminders[index];

        return _ReminderCard(
          reminder: reminder,
          onChanged: (_) {
            _toggleReminder(reminder);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 42,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border.withValues(
            alpha: 0.65,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withValues(
                alpha: 0.10,
              ),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 36,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No reminders yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a reminder to help keep the day organized.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ADD REMINDER BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildAddReminderButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        4,
        18,
        14,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _showAddReminderDialog,
          icon: const Icon(
            Icons.add_rounded,
            size: 24,
          ),
          label: const Text(
            'Add Reminder',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ---------------------------------------------------------------------------

  Widget _buildBottomNavigation(
    BuildContext context,
  ) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, -3),
              color: Colors.black.withValues(
                alpha: 0.07,
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _navItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: false,
              onTap: () {
                Navigator.of(context).maybePop();
              },
            ),
            _navItem(
              icon: Icons.bar_chart_outlined,
              label: 'Progress',
              selected: false,
              onTap: () {
                Navigator.of(context).maybePop();
              },
            ),
            _navItem(
              icon: Icons.notifications_rounded,
              label: 'Reminders',
              selected: true,
              onTap: () {},
            ),
            _navItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.textMedium,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primaryGreen
                    : AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CIRCLE BUTTON
  // ---------------------------------------------------------------------------

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1.5,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTERING
  // ---------------------------------------------------------------------------

  List<_ReminderItem> _filteredReminders() {
    switch (_selectedTab) {
      case 1:
        return _reminders
            .where(
              (reminder) => !reminder.isCompleted,
            )
            .toList();

      case 2:
        return _reminders
            .where(
              (reminder) => reminder.isCompleted,
            )
            .toList();

      default:
        return _reminders.toList();
    }
  }

  // ---------------------------------------------------------------------------
  // COMPLETE / UNCOMPLETE REMINDER
  // ---------------------------------------------------------------------------

  void _toggleReminder(
    _ReminderItem reminder,
  ) {
    setState(() {
      reminder.isCompleted =
          !reminder.isCompleted;
    });
  }

  // ---------------------------------------------------------------------------
  // ADD REMINDER DIALOG
  // ---------------------------------------------------------------------------

  Future<void> _showAddReminderDialog() async {
    final result =
        await showDialog<_ReminderItem>(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return const _AddReminderDialog();
      },
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _reminders.add(result);
    });
  }
}

// =============================================================================
// ADD REMINDER DIALOG
// =============================================================================

class _AddReminderDialog extends StatefulWidget {
  const _AddReminderDialog();

  @override
  State<_AddReminderDialog> createState() =>
      _AddReminderDialogState();
}

class _AddReminderDialogState
    extends State<_AddReminderDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  TimeOfDay? _selectedTime;

  _ReminderIconType _selectedIcon =
      _ReminderIconType.activity;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add Reminder',
        style: TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Reminder title',
                hintText: 'Enter reminder name',
                prefixIcon: Icon(
                  Icons.edit_outlined,
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Add a short note',
                prefixIcon: Icon(
                  Icons.notes_outlined,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.access_time_rounded,
                color: AppColors.primaryGreen,
              ),
              title: Text(
                _selectedTime == null
                    ? 'Choose time'
                    : _selectedTime!.format(context),
              ),
              onTap: _chooseTime,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<_ReminderIconType>(
              initialValue: _selectedIcon,
              decoration: const InputDecoration(
                labelText: 'Reminder type',
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),
              items: _ReminderIconType.values
                  .map(
                    (type) {
                      return DropdownMenuItem<
                          _ReminderIconType>(
                        value: type,
                        child: Text(
                          type.label,
                        ),
                      );
                    },
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  _selectedIcon = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
          ),
        ),
        ElevatedButton(
          onPressed: _addReminder,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primaryGreen,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Add',
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TIME PICKER
  // ---------------------------------------------------------------------------

  Future<void> _chooseTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() {
      _selectedTime = picked;
    });
  }

  // ---------------------------------------------------------------------------
  // ADD
  // ---------------------------------------------------------------------------

  void _addReminder() {
    final title = _titleController.text.trim();
    final description =
        _descriptionController.text.trim();

    if (title.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a title and choose a time.',
          ),
        ),
      );
      return;
    }

    final reminder = _ReminderItem(
      id: DateTime.now()
          .microsecondsSinceEpoch
          .toString(),
      title: title,
      description: description,
      time: _selectedTime!.format(context),
      iconType: _selectedIcon,
    );

    Navigator.of(context).pop(reminder);
  }
}

// =============================================================================
// REMINDER CARD
// =============================================================================

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({
    required this.reminder,
    required this.onChanged,
  });

  final _ReminderItem reminder;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.border.withValues(
            alpha: 0.7,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  reminder.iconType.backgroundColor,
            ),
            child: Icon(
              reminder.iconType.icon,
              size: 23,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: reminder.isCompleted
                        ? AppColors.textMedium
                        : AppColors.textDark,
                    decoration:
                        reminder.isCompleted
                            ? TextDecoration
                                .lineThrough
                            : null,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reminder.time,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMedium,
                  ),
                ),
                if (reminder
                    .description
                    .isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    reminder.description,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 4),
          Checkbox(
            value: reminder.isCompleted,
            onChanged: onChanged,
            activeColor:
                AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// REMINDER DATA
// =============================================================================

class _ReminderItem {
  _ReminderItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.iconType,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final _ReminderIconType iconType;

  bool isCompleted = false;
}

// =============================================================================
// REMINDER ICON TYPES
// =============================================================================

enum _ReminderIconType {
  medicine,
  food,
  walk,
  water,
  activity,
  appointment,
}

extension _ReminderIconTypeExtension
    on _ReminderIconType {
  IconData get icon {
    switch (this) {
      case _ReminderIconType.medicine:
        return Icons.medication_rounded;

      case _ReminderIconType.food:
        return Icons.restaurant_rounded;

      case _ReminderIconType.walk:
        return Icons.directions_walk_rounded;

      case _ReminderIconType.water:
        return Icons.water_drop_rounded;

      case _ReminderIconType.activity:
        return Icons.psychology_rounded;

      case _ReminderIconType.appointment:
        return Icons.calendar_month_rounded;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case _ReminderIconType.medicine:
        return const Color(0xFFE5A9B8);

      case _ReminderIconType.food:
        return const Color(0xFFE7B66A);

      case _ReminderIconType.walk:
        return const Color(0xFF7CCB9B);

      case _ReminderIconType.water:
        return const Color(0xFF79B9E8);

      case _ReminderIconType.activity:
        return const Color(0xFFD78AB8);

      case _ReminderIconType.appointment:
        return const Color(0xFF8FB6D9);
    }
  }

  String get label {
    switch (this) {
      case _ReminderIconType.medicine:
        return 'Medicine';

      case _ReminderIconType.food:
        return 'Food';

      case _ReminderIconType.walk:
        return 'Walk';

      case _ReminderIconType.water:
        return 'Water';

      case _ReminderIconType.activity:
        return 'Memory Activity';

      case _ReminderIconType.appointment:
        return 'Appointment';
    }
  }
}