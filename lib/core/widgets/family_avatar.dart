import 'package:flutter/material.dart';
import '../../data/models/family_member.dart';

/// Reusable circular avatar for a [FamilyMember].
///
/// Shows the member's real photo (`member.imagePath`) clipped into a
/// circle. If the asset is missing or fails to decode, it falls back
/// to a colored circle with the member's initial instead of crashing.
class FamilyAvatar extends StatelessWidget {
  final FamilyMember member;
  final double radius;

  const FamilyAvatar({super.key, required this.member, this.radius = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.asset(
          member.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: member.avatarColor,
              alignment: Alignment.center,
              child: Text(
                member.name.isNotEmpty ? member.name[0] : '?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: radius * 0.6,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}