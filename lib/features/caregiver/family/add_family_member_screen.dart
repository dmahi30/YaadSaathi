import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';

typedef FamilyMemberSaveCallback = Future<void> Function({
  required String name,
  required String relationship,
  required String details,
  required File? image,
});

class FamilyMemberFormResult {
  const FamilyMemberFormResult();
}

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({
    super.key,
    required this.onSave,
    this.initialName = '',
    this.initialRelationship = '',
    this.initialDetails = '',
  });

  final FamilyMemberSaveCallback onSave;

  final String initialName;
  final String initialRelationship;
  final String initialDetails;

  @override
  State<AddFamilyMemberScreen> createState() =>
      _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState
    extends State<AddFamilyMemberScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _detailsController;

  String _relationship = '';

  File? _selectedImage;

  bool _saving = false;

  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _relationshipOptions = const [
    'Mother',
    'Father',
    'Spouse',
    'Daughter',
    'Son',
    'Granddaughter',
    'Grandson',
    'Sibling',
    'Friend',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.initialName,
    );

    _detailsController = TextEditingController(
      text: widget.initialDetails,
    );

    _relationship = widget.initialRelationship;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // PHOTO
  // ===========================================================================

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null || !mounted) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  // ===========================================================================
  // RELATIONSHIP
  // ===========================================================================

  Future<void> _showRelationshipPicker() async {
    final selected = await showModalBottomSheet<String>(
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
              16,
              14,
              16,
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
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Select Relationship',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        _relationshipOptions.length,
                    itemBuilder: (context, index) {
                      final relationship =
                          _relationshipOptions[index];

                      return ListTile(
                        title: Text(
                          relationship,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing:
                            relationship ==
                                    _relationship
                                ? const Icon(
                                    Icons
                                        .check_circle_rounded,
                                    color: AppColors
                                        .primaryGreen,
                                  )
                                : null,
                        onTap: () {
                          Navigator.of(sheetContext)
                              .pop(relationship);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _relationship = selected;
    });
  }

  // ===========================================================================
  // SAVE
  // ===========================================================================

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final name = _nameController.text.trim();
    final relationship = _relationship.trim();
    final details = _detailsController.text.trim();

    if (name.isEmpty || relationship.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a name and select a relationship.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await widget.onSave(
        name: name,
        relationship: relationship,
        details: details,
        image: _selectedImage,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(
        const FamilyMemberFormResult(),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      final message = _firebaseErrorMessage(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(message),
        ),
      );
    }
  }

  String _firebaseErrorMessage(Object error) {
    final text = error.toString();

    if (text.contains('permission-denied')) {
      return 'Firestore permission denied. Please check the Firebase rules for family members.';
    }

    if (text.contains('unauthenticated')) {
      return 'Your caregiver session is not signed in. Please sign in again.';
    }

    if (text.contains('failed-precondition')) {
      return 'The patient profile is not linked correctly.';
    }

    if (text.contains('network-request-failed')) {
      return 'Network connection failed. Please check your internet and try again.';
    }

    if (text.trim().isNotEmpty) {
      return text
          .replaceFirst('Exception: ', '')
          .replaceFirst('FirebaseException: ', '');
    }

    return 'Unable to save the family member. Please try again.';
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final isEditing =
        widget.initialName.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _circleButton(
                          icon: Icons
                              .arrow_back_ios_new_rounded,
                          onTap: () {
                            Navigator.of(context)
                                .maybePop();
                          },
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            isEditing
                                ? 'Edit Family Member'
                                : 'Add Family Member',
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  AppColors.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // -----------------------------------------------------------
                    // PHOTO
                    // -----------------------------------------------------------

                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 118,
                              height: 118,
                              decoration:
                                  BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(
                                  0xFFE8E8ED,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                image:
                                    _selectedImage !=
                                            null
                                        ? DecorationImage(
                                            image:
                                                FileImage(
                                              _selectedImage!,
                                            ),
                                            fit: BoxFit
                                                .cover,
                                          )
                                        : null,
                              ),
                              child:
                                  _selectedImage ==
                                          null
                                      ? const Icon(
                                          Icons
                                              .camera_alt_rounded,
                                          size: 40,
                                          color: AppColors
                                              .textMedium,
                                        )
                                      : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Add Photo',
                            style: TextStyle(
                              fontSize: 15,
                              color:
                                  AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 42),

                    // -----------------------------------------------------------
                    // NAME
                    // -----------------------------------------------------------

                    const _FormLabel(
                      text: 'Name',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      textCapitalization:
                          TextCapitalization.words,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textDark,
                      ),
                      decoration:
                          _inputDecoration(
                        hint: 'Enter name',
                      ),
                    ),

                    const SizedBox(height: 28),

                    // -----------------------------------------------------------
                    // RELATIONSHIP
                    // -----------------------------------------------------------

                    const _FormLabel(
                      text: 'Relationship',
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _showRelationshipPicker,
                      borderRadius:
                          BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                const Color(0xFFE3E3E3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _relationship.isEmpty
                                    ? 'Select relationship'
                                    : _relationship,
                                style: TextStyle(
                                  fontSize: 17,
                                  color:
                                      _relationship
                                              .isEmpty
                                          ? Colors.grey
                                          : AppColors
                                              .textDark,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons
                                  .keyboard_arrow_down_rounded,
                              color:
                                  AppColors.textMedium,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // -----------------------------------------------------------
                    // DETAILS
                    // -----------------------------------------------------------

                    const _FormLabel(
                      text:
                          'Add more details (optional)',
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _detailsController,
                      maxLines: 5,
                      textCapitalization:
                          TextCapitalization.sentences,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.4,
                        color: AppColors.textDark,
                      ),
                      decoration:
                          _inputDecoration(
                        hint:
                            'E.g. a short note, their role, or something special about them...',
                        alignLabelWithHint: true,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // -----------------------------------------------------------
                    // SAVE
                    // -----------------------------------------------------------

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _saving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primaryGreen,
                          disabledBackgroundColor:
                              AppColors.primaryGreen
                                  .withValues(
                            alpha: 0.45,
                          ),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing
                                    ? 'Save Changes'
                                    : 'Save',
                                style:
                                    const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 17,
        color: Colors.grey,
      ),
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE3E3E3),
        ),
      ),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE3E3E3),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primaryGreen,
          width: 1.5,
        ),
      ),
    );
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
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }
}