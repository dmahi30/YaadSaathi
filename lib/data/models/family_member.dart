import 'package:flutter/material.dart';

class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final Color avatarColor;
  final String imagePath;
  final String voiceText;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.avatarColor,
    required this.imagePath,
    required this.voiceText,
  });
}