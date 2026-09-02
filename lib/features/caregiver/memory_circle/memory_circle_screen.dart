import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/family_avatar.dart';
import '../../../core/widgets/speaker_button.dart';
import '../../../data/fake_data/family_members.dart';
import '../../../data/models/family_member.dart';

class MemoryCircleScreen extends StatelessWidget {
  const MemoryCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Memory Circle'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'People You Love',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Tap a person to remember them and hear their message.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              ...FakeFamilyData.members.map(
                (member) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _MemoryCircleCard(member: member),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemoryCircleCard extends StatelessWidget {
  final FamilyMember member;
  const _MemoryCircleCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          FamilyAvatar(member: member, radius: 56),
          const SizedBox(height: 14),
          Text(
            member.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            member.relation,
            style: const TextStyle(color: AppColors.textMedium, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpeakerButton(text: member.voiceText, size: 48),
              const SizedBox(width: 12),
              Text(
                'Hear Message',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}