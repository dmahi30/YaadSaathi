import 'package:flutter/material.dart';
import '../models/family_member.dart';

class FakeFamilyData {
  FakeFamilyData._();

  static const String _basePath = 'assets/images/characters';

  static const List<FamilyMember> members = [
    FamilyMember(
      id: 'meera',
      name: 'Meera',
      relation: 'Daughter',
      avatarColor: Color(0xFFF3B6C4),
      imagePath: '$_basePath/meera.jpeg',
      voiceText: "Yes! That's Meera, your daughter.",
    ),
    FamilyMember(
      id: 'rahul',
      name: 'Rahul',
      relation: 'Son',
      avatarColor: Color(0xFFA8D0E6),
      imagePath: '$_basePath/rahul.jpeg',
      voiceText: "Yes! That's Rahul, your son.",
    ),
    FamilyMember(
      id: 'asha',
      name: 'Asha',
      relation: 'Granddaughter',
      avatarColor: Color(0xFFFFD9A0),
      imagePath: '$_basePath/asha.jpeg',
      voiceText: "Yes! That's Asha, your granddaughter.",
    ),
    FamilyMember(
      id: 'arun',
      name: 'Arun',
      relation: 'Son',
      avatarColor: Color(0xFFC8E6C9),
      imagePath: '$_basePath/arun.jpeg',
      voiceText: "Yes! That's Arun, your son.",
    ),
    FamilyMember(
      id: 'dadi',
      name: 'Dadi',
      relation: 'Grandmother',
      avatarColor: Color(0xFFD8BFD8),
      imagePath: '$_basePath/dadi.jpeg',
      voiceText: "Yes! That's Dadi.",
    ),
  ];
}