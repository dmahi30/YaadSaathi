import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/speaker_button.dart';
import '../dashboard/caregiver_dashboard_screen.dart';
import '../progress/progress_screen.dart';
import '../reminders/reminders_screen.dart';
import '../settings/caregiver_settings_screen.dart';
import 'add_family_member_screen.dart';

class FamilyDataScreen extends StatefulWidget {
  const FamilyDataScreen({
    super.key,
  });

  @override
  State<FamilyDataScreen> createState() => _FamilyDataScreenState();
}

class _FamilyDataScreenState extends State<FamilyDataScreen> {
  int _selectedTab = 0;

  String? _patientId;
  bool _loadingPatient = true;
  String? _patientError;

  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  // ===========================================================================
  // PATIENT ID
  // ===========================================================================

  Future<void> _loadPatientId() async {
    if (!mounted) return;

    setState(() {
      _loadingPatient = true;
      _patientError = null;
    });

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        _loadingPatient = false;
        _patientError = 'No signed-in caregiver account was found.';
      });
      return;
    }

    try {
      final caregiverSnapshot = await FirebaseFirestore.instance
          .collection('caregivers')
          .doc(user.uid)
          .get();

      if (!caregiverSnapshot.exists) {
        if (!mounted) return;

        setState(() {
          _loadingPatient = false;
          _patientError =
              'Caregiver information could not be found for this account.';
        });
        return;
      }

      final caregiverData = caregiverSnapshot.data();

      final patientId =
          caregiverData?['patientId']?.toString().trim() ?? '';

      if (patientId.isEmpty) {
        if (!mounted) return;

        setState(() {
          _loadingPatient = false;
          _patientError =
              'No patient profile is linked to this caregiver account.';
        });
        return;
      }

      if (!mounted) return;

      setState(() {
        _patientId = patientId;
        _loadingPatient = false;
        _patientError = null;
      });
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingPatient = false;
        _patientError =
            e.message?.trim().isNotEmpty == true
                ? e.message
                : 'Unable to load the connected patient profile.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingPatient = false;
        _patientError =
            'Unable to load the connected patient profile.';
      });
    }
  }

  CollectionReference<Map<String, dynamic>>? get _familyCollection {
    final patientId = _patientId?.trim();

    if (patientId == null || patientId.isEmpty) {
      return null;
    }

    return FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .collection('family_members');
  }

  // ===========================================================================
  // ADD FAMILY MEMBER
  // ===========================================================================

  Future<void> _showAddFamilyMember() async {
    final patientId = _patientId?.trim();

    if (patientId == null || patientId.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _patientError ??
                'Please complete the patient profile first.',
          ),
        ),
      );
      return;
    }

    final result = await Navigator.of(context).push<FamilyMemberFormResult>(
      MaterialPageRoute(
        builder: (_) => AddFamilyMemberScreen(
          onSave: ({
            required String name,
            required String relationship,
            required String details,
            required File? image,
          }) async {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'unauthenticated',
                message: 'No signed-in caregiver account was found.',
              );
            }

            final collection = _familyCollection;

            if (collection == null) {
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'failed-precondition',
                message: 'No patient profile is linked.',
              );
            }

            await collection.add({
              'name': name.trim(),
              'relationship': relationship.trim(),
              'details': details.trim(),
              'patientId': patientId,
              'caregiverId': user.uid,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            });
          },
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {});
  }

  // ===========================================================================
  // FAMILY MEMBER OPTIONS
  // ===========================================================================

  Future<void> _showFamilyMemberOptions(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final collection = _familyCollection;

    if (collection == null) {
      return;
    }

    final name = _stringValue(data['name']);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name.isEmpty ? 'Family Member' : name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(
                    Icons.edit_rounded,
                    color: AppColors.primaryGreen,
                  ),
                  title: const Text(
                    'Edit',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();

                    _showEditFamilyMember(
                      documentId,
                      data,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                  title: const Text(
                    'Delete',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();

                    _deleteFamilyMember(
                      documentId,
                      name,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // EDIT
  // ===========================================================================

  Future<void> _showEditFamilyMember(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final collection = _familyCollection;

    if (collection == null) {
      return;
    }

    final result = await Navigator.of(context).push<FamilyMemberFormResult>(
      MaterialPageRoute(
        builder: (_) => AddFamilyMemberScreen(
          initialName: _stringValue(data['name']),
          initialRelationship: _stringValue(
            data['relationship'],
          ),
          initialDetails: _stringValue(data['details']),
          onSave: ({
            required String name,
            required String relationship,
            required String details,
            required File? image,
          }) async {
            await collection.doc(documentId).update({
              'name': name.trim(),
              'relationship': relationship.trim(),
              'details': details.trim(),
              'updatedAt': FieldValue.serverTimestamp(),
            });
          },
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {});
  }

  // ===========================================================================
  // DELETE
  // ===========================================================================

  Future<void> _deleteFamilyMember(
    String documentId,
    String name,
  ) async {
    final collection = _familyCollection;

    if (collection == null) {
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Family Member',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            name.trim().isEmpty
                ? 'Are you sure you want to remove this family member?'
                : 'Are you sure you want to remove $name?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    try {
      await collection.doc(documentId).delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Family member removed successfully.',
          ),
        ),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message?.trim().isNotEmpty == true
                ? e.message!
                : 'Unable to delete the family member.',
          ),
        ),
      );
    }
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: _buildFamilyContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFamilyContent() {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: _selectedTab == 0
              ? _buildFamilyMembers()
              : _buildTabPlaceholder(),
        ),
      ],
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        18,
        10,
        18,
        0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circleButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () {
                  Navigator.of(context).maybePop();
                },
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Family Data',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              SpeakerButton(
                text:
                    'Family Data. Add and manage your loved ones.',
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Add and manage your loved ones, memories and important information for personalized activities.',
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _showAddFamilyMember,
              icon: const Icon(
                Icons.add_rounded,
                size: 27,
              ),
              label: const Text(
                'Add Family Member',
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
          const SizedBox(height: 12),
          Row(
            children: [
              _FamilyTab(
                label: 'Family Members',
                selected: _selectedTab == 0,
                onTap: () {
                  setState(() {
                    _selectedTab = 0;
                  });
                },
              ),
              _FamilyTab(
                label: 'Memories',
                selected: _selectedTab == 1,
                onTap: () {
                  setState(() {
                    _selectedTab = 1;
                  });
                },
              ),
              _FamilyTab(
                label: 'Important Dates',
                selected: _selectedTab == 2,
                onTap: () {
                  setState(() {
                    _selectedTab = 2;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // FAMILY MEMBERS
  // ===========================================================================

  Widget _buildFamilyMembers() {
    if (_loadingPatient) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGreen,
        ),
      );
    }

    final collection = _familyCollection;

    if (collection == null) {
      return _emptyFamilyState(
        icon: Icons.person_search_rounded,
        title: 'Patient profile required',
        subtitle: _patientError ??
            'Complete the patient profile before adding family members.',
        showAddButton: false,
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: collection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
          );
        }

        if (snapshot.hasError) {
          return _emptyFamilyState(
            icon: Icons.error_outline_rounded,
            title: 'Unable to load family data',
            subtitle:
                'Please check your connected account and Firestore access.',
            showAddButton: true,
          );
        }

        final documents = snapshot.data?.docs ?? [];

        if (documents.isEmpty) {
          return _emptyFamilyState(
            icon: Icons.groups_rounded,
            title: 'No family members yet',
            subtitle:
                'Add a family member to create a more personal and familiar experience.',
            showAddButton: true,
          );
        }

        final sortedDocuments = [...documents];

        sortedDocuments.sort((a, b) {
          final aCreated = a.data()['createdAt'];
          final bCreated = b.data()['createdAt'];

          if (aCreated is Timestamp && bCreated is Timestamp) {
            return aCreated.compareTo(bCreated);
          }

          return 0;
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            16,
            18,
            28,
          ),
          child: Wrap(
            spacing: 14,
            runSpacing: 18,
            children: sortedDocuments.map((document) {
              final data = document.data();

              return _FamilyMemberCard(
                name: _stringValue(data['name']),
                relationship:
                    _stringValue(data['relationship']),
                details: _stringValue(data['details']),
                onTap: () {
                  _showFamilyMemberOptions(
                    document.id,
                    data,
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // EMPTY STATE
  // ===========================================================================

  Widget _emptyFamilyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showAddButton,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          30,
          28,
          30,
          30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(
                  alpha: 0.10,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColors.textMedium,
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _showAddFamilyMember,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text(
                    'Add Family Member',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // OTHER TABS
  // ===========================================================================

  Widget _buildTabPlaceholder() {
    final isMemories = _selectedTab == 1;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMemories
                  ? Icons.photo_album_rounded
                  : Icons.event_rounded,
              size: 56,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 16),
            Text(
              isMemories
                  ? 'Memories'
                  : 'Important Dates',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isMemories
                  ? 'Memories connected to family members can be added here.'
                  : 'Important birthdays, anniversaries and events can be added here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM NAVIGATION
  // ===========================================================================

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          4,
          8,
          4,
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
          children: [
            _BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: false,
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) =>
                        const CaregiverDashboardScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_rounded,
              label: 'Progress',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const ProgressScreen(),
                  ),
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.notifications_rounded,
              label: 'Reminders',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const CaregiverRemindersScreen(),
                  ),
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.groups_rounded,
              label: 'Family',
              selected: true,
              onTap: () {},
            ),
            _BottomNavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const CaregiverSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // HELPERS
  // ===========================================================================

  String _stringValue(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

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
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FAMILY MEMBER CARD
// =============================================================================

class _FamilyMemberCard extends StatelessWidget {
  const _FamilyMemberCard({
    required this.name,
    required this.relationship,
    required this.details,
    required this.onTap,
  });

  final String name;
  final String relationship;
  final String details;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.border.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  size: 48,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              name.isEmpty ? 'Unnamed' : name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              relationship.isEmpty
                  ? 'Family member'
                  : relationship,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMedium,
              ),
            ),
            if (details.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(top: 2),
                child: Text(
                  details,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 9,
                    color:
                        AppColors.textMedium,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// FAMILY TAB
// =============================================================================

class _FamilyTab extends StatelessWidget {
  const _FamilyTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 2,
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected
                    ? AppColors.primaryGreen
                    : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: selected
                  ? FontWeight.w800
                  : FontWeight.w600,
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// BOTTOM NAV ITEM
// =============================================================================

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 4,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: selected
                      ? AppColors.primaryGreen
                      : AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}