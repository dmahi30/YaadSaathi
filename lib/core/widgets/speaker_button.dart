import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../services/audio_service.dart';

class SpeakerButton extends StatefulWidget {
  final String text;
  final double size;

  const SpeakerButton({super.key, required this.text, this.size = 56});

  @override
  State<SpeakerButton> createState() => _SpeakerButtonState();
}

class _SpeakerButtonState extends State<SpeakerButton> {
  final AudioService _audio = AudioService();
  bool _playing = false;

  Future<void> _play() async {
    setState(() => _playing = true);
    await _audio.speak(widget.text);
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playing ? null : _play,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: AppColors.primaryGreenLight,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGreen, width: 1.5),
        ),
        child: Icon(
          Icons.volume_up,
          color: AppColors.primaryGreen,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}