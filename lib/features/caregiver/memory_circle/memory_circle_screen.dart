import 'package:flutter/material.dart';

import '../../../data/fake_data/family_members.dart';
import '../../../data/models/family_member.dart';

/// "5. Memory Circle" screen — caregiver view of the patient's
/// Memory Circle, listing each person with a photo, relation,
/// a play button for their voice line, a little waveform icon,
/// and an overflow menu.
///
/// Data comes straight from [fakeFamilyMembers] (see Hour 0–1 shortcut
/// in data/fake_data/family_members.dart) — no upload form needed yet.
class MemoryCircleScreen extends StatefulWidget {
  final String patientName;

  const MemoryCircleScreen({super.key, this.patientName = "Leima"});

  @override
  State<MemoryCircleScreen> createState() => _MemoryCircleScreenState();
}

class _MemoryCircleScreenState extends State<MemoryCircleScreen> {
  String? _playingId;

  static const _green = Color(0xFF3FA34D);

  void _togglePlay(FamilyMember member) {
    setState(() {
      _playingId = _playingId == member.id ? null : member.id;
    });
    // Hook up to AudioService.play(member.voiceLinePath) for real playback.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Memory Circle',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "People in ${widget.patientName}'s Memory Circle",
                    style: const TextStyle(color: Colors.black54, fontSize: 13.5),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Real flow would push AddPersonScreen here.
                  },
                  icon: const Icon(Icons.add, size: 18, color: _green),
                  label: const Text(
                    'Add Person',
                    style: TextStyle(color: _green, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              itemCount: fakeFamilyMembers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final member = fakeFamilyMembers[index];
                return _MemberCard(
                  member: member,
                  isPlaying: _playingId == member.id,
                  onPlayTap: () => _togglePlay(member),
                  accentColor: _green,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(accentColor: _green),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final FamilyMember member;
  final bool isPlaying;
  final VoidCallback onPlayTap;
  final Color accentColor;

  const _MemberCard({
    required this.member,
    required this.isPlaying,
    required this.onPlayTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECECEC)),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          _Avatar(member: member),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15.5),
                ),
                const SizedBox(height: 2),
                Text(
                  member.relation,
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onPlayTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle_fill,
                color: accentColor,
                size: 30,
              ),
            ),
          ),
          const SizedBox(width: 6),
          _Waveform(color: accentColor, animate: isPlaying),
          const SizedBox(width: 4),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.more_vert, color: Colors.black45, size: 20),
            onPressed: () {
              // Show edit/remove menu for this member.
            },
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final FamilyMember member;
  const _Avatar({required this.member});

  @override
  Widget build(BuildContext context) {
    final hasPhoto = member.photoUrl.isNotEmpty;
    return CircleAvatar(
      radius: 26,
      backgroundColor: const Color(0xFFE0E0E0),
      backgroundImage: hasPhoto ? AssetImage(member.photoUrl) : null,
      child: hasPhoto
          ? null
          : Text(
              member.name.isNotEmpty ? member.name[0] : '?',
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
            ),
    );
  }
}

/// Small static (or subtly animated) waveform icon, standing in for
/// an audio-preview visualization next to the play button.
class _Waveform extends StatelessWidget {
  final Color color;
  final bool animate;
  const _Waveform({required this.color, this.animate = false});

  static const _heights = [6.0, 12.0, 18.0, 12.0, 7.0, 14.0, 9.0];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _heights
            .map(
              (h) => Container(
                width: 2.4,
                height: animate ? h : h * 0.7,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final Color accentColor;
  const _BottomNav({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.grid_view_rounded, 'Dashboard'),
      (Icons.show_chart_rounded, 'Progress'),
      (Icons.diversity_3_rounded, 'Memory Circle'),
      (Icons.notifications_none_rounded, 'Alerts'),
      (Icons.menu_rounded, 'More'),
    ];
    const activeIndex = 2; // Memory Circle tab

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEFEFEF))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final active = i == activeIndex;
            final (icon, label) = items[i];
            final color = active ? accentColor : Colors.black38;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(color: color, fontSize: 10.5, fontWeight: active ? FontWeight.w600 : FontWeight.w400),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}