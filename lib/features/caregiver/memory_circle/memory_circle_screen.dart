import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_settings_controller.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/family_avatar.dart';
import '../../../data/fake_data/family_members.dart';
import '../../../data/models/family_member.dart';

class MemoryCircleScreen extends StatefulWidget {
  const MemoryCircleScreen({super.key});

  @override
  State<MemoryCircleScreen> createState() => _MemoryCircleScreenState();
}

class _MemoryCircleScreenState extends State<MemoryCircleScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  String? _currentlyPlaying;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _currentlyPlaying = null;
        });
      }
    });
  }

  // ------------------------------------------------------------
  // Localized Memory Circle messages
  // ------------------------------------------------------------

  String _getMessage(FamilyMember member, AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        switch (member.id) {
          case 'meera':
            return "Yes! That's Meera, your daughter.";
          case 'rahul':
            return "Yes! That's Rahul, your son.";
          case 'asha':
            return "Yes! That's Asha, your granddaughter.";
          case 'arun':
            return "Yes! That's Arun, your son.";
          case 'dadi':
            return "Yes! That's Dadi, your grandmother.";
          default:
            return "This is ${member.name}.";
        }

      case AppLanguage.hindi:
        switch (member.id) {
          case 'meera':
            return "हाँ! यह मीरा है, आपकी बेटी।";
          case 'rahul':
            return "हाँ! यह राहुल है, आपका बेटा।";
          case 'asha':
            return "हाँ! यह आशा है, आपकी पोती।";
          case 'arun':
            return "हाँ! यह अरुण है, आपका बेटा।";
          case 'dadi':
            return "हाँ! यह दादी हैं।";
          default:
            return "यह ${member.name} हैं।";
        }

      case AppLanguage.marathi:
        switch (member.id) {
          case 'meera':
            return "हो! ही मीरा आहे, तुमची मुलगी.";
          case 'rahul':
            return "हो! हा राहुल आहे, तुमचा मुलगा.";
          case 'asha':
            return "हो! ही आशा आहे, तुमची नात.";
          case 'arun':
            return "हो! हा अरुण आहे, तुमचा मुलगा.";
          case 'dadi':
            return "हो! ही आजी आहे.";
          default:
            return "ही ${member.name} आहे.";
        }

      case AppLanguage.bengali:
        switch (member.id) {
          case 'meera':
            return "হ্যাঁ! ইনি মীরা, আপনার মেয়ে।";
          case 'rahul':
            return "হ্যাঁ! ইনি রাহুল, আপনার ছেলে।";
          case 'asha':
            return "হ্যাঁ! ইনি আশা, আপনার নাতনি।";
          case 'arun':
            return "হ্যাঁ! ইনি অরুণ, আপনার ছেলে।";
          case 'dadi':
            return "হ্যাঁ! ইনি দিদা।";
          default:
            return "ইনি ${member.name}।";
        }

      case AppLanguage.assamese:
        switch (member.id) {
          case 'meera':
            return "হয়! এয়া মীৰা, আপোনাৰ জীয়াৰী।";
          case 'rahul':
            return "হয়! এয়া ৰাহুল, আপোনাৰ পুত্ৰ।";
          case 'asha':
            return "হয়! এয়া আশা, আপোনাৰ নাতিনী।";
          case 'arun':
            return "হয়! এয়া অৰুণ, আপোনাৰ পুত্ৰ।";
          case 'dadi':
            return "হয়! এয়া আইতা।";
          default:
            return "এয়া ${member.name}।";
        }
    }
  }

  // ------------------------------------------------------------
  // TTS language
  // ------------------------------------------------------------

  String _getTtsLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en-IN';

      case AppLanguage.hindi:
        return 'hi-IN';

      case AppLanguage.marathi:
        return 'mr-IN';

      case AppLanguage.bengali:
        return 'bn-IN';

      case AppLanguage.assamese:
        return 'as-IN';
    }
  }

  // ------------------------------------------------------------
  // Play the appropriate message
  // ------------------------------------------------------------

  Future<void> _playMessage(FamilyMember member) async {
    final selectedLanguage =
        AppLanguageController.instance.language;

    await _audioPlayer.stop();
    await _tts.stop();

    // Tapping the currently playing person stops the message.
    if (_currentlyPlaying == member.id) {
      if (mounted) {
        setState(() {
          _currentlyPlaying = null;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _currentlyPlaying = member.id;
      });
    }

    try {
      // ----------------------------------------------------------
      // HINDI → Use the existing recorded MP3
      // ----------------------------------------------------------
      if (selectedLanguage == AppLanguage.hindi) {
        await _audioPlayer.play(
          AssetSource('audio/${member.id}.mp3'),
        );
      }

      // ----------------------------------------------------------
      // OTHER LANGUAGES → Use TTS
      // ----------------------------------------------------------
      else {
        final message = _getMessage(
          member,
          selectedLanguage,
        );

        await _tts.setLanguage(
          _getTtsLanguage(selectedLanguage),
        );

        await _tts.setSpeechRate(
          appSettings.speechRate,
        );

        await _tts.setPitch(1.0);

        await _tts.awaitSpeakCompletion(true);

        await _tts.speak(message);

        if (mounted) {
          setState(() {
            _currentlyPlaying = null;
          });
        }
      }
    } catch (e) {
      debugPrint('Memory Circle audio error: $e');

      if (mounted) {
        setState(() {
          _currentlyPlaying = null;
        });
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguageController.instance,
      builder: (context, _) {
        final l10n = AppLocalizations.current();

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            title: Text(l10n.memoryCircle),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.peopleYouLove,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.tapPersonToRemember,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  ...FakeFamilyData.members.map(
                    (member) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: 16),

                      child: _MemoryCircleCard(
                        member: member,
                        isPlaying:
                            _currentlyPlaying == member.id,
                        onPlay: () =>
                            _playMessage(member),
                        localizedName:
                            l10n.familyMemberName(member.id),
                        hearMessage:
                            l10n.hearMessage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MemoryCircleCard extends StatelessWidget {
  final FamilyMember member;
  final bool isPlaying;
  final VoidCallback onPlay;
  final String localizedName;
  final String hearMessage;

  const _MemoryCircleCard({
    required this.member,
    required this.isPlaying,
    required this.onPlay,
    required this.localizedName,
    required this.hearMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          FamilyAvatar(
            member: member,
            radius: 56,
          ),

          const SizedBox(height: 14),

          Text(
            localizedName,
            style: Theme.of(context)
                .textTheme
                .titleLarge,
          ),

          const SizedBox(height: 4),

          Text(
            member.relation,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [
              GestureDetector(
                onTap: onPlay,

                child: Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color:
                        AppColors.primaryGreenLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          AppColors.primaryGreen,
                      width: 1.5,
                    ),
                  ),

                  child: Icon(
                    isPlaying
                        ? Icons.stop
                        : Icons.volume_up,
                    color:
                        AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                hearMessage,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color:
                          AppColors.primaryGreen,
                      fontWeight:
                          FontWeight.w600,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}