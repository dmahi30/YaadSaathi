import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/state/patient_name_controller.dart';
import '../games/face_name_match/face_name_match_screen.dart';
import '../settings/patient_settings_screen.dart';

class VoiceAssistantScreen extends StatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  State<VoiceAssistantScreen> createState() =>
      _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends State<VoiceAssistantScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final AudioService _audioService = AudioService();

  bool _isListening = false;
  String _spokenText = '';

  late String _response;

  // ------------------------------------------------------------
  // SPEECH LOCALE
  // ------------------------------------------------------------

  String _speechLocale(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en_IN';

      case AppLanguage.hindi:
        return 'hi_IN';

      case AppLanguage.marathi:
        return 'mr_IN';

      case AppLanguage.bengali:
        return 'bn_IN';

      case AppLanguage.assamese:
        return 'as_IN';
    }
  }

  // ------------------------------------------------------------
  // MULTILINGUAL TEXT
  // ------------------------------------------------------------

  String _text(
    AppLanguage language,
    String english,
    String hindi,
    String marathi,
    String bengali,
    String assamese,
  ) {
    switch (language) {
      case AppLanguage.english:
        return english;

      case AppLanguage.hindi:
        return hindi;

      case AppLanguage.marathi:
        return marathi;

      case AppLanguage.bengali:
        return bengali;

      case AppLanguage.assamese:
        return assamese;
    }
  }

  // ------------------------------------------------------------
  // SCREEN TEXT
  // ------------------------------------------------------------

  String _screenTitle(AppLanguage language) {
    return _text(
      language,
      'Voice Assistant',
      'वॉइस असिस्टेंट',
      'व्हॉइस असिस्टंट',
      'ভয়েস অ্যাসিস্ট্যান্ট',
      'ভইচ সহায়ক',
    );
  }

  String _greeting(AppLanguage language, String name) {
    if (name.isEmpty) {
      return _text(
        language,
        'Hello! 👋',
        'नमस्ते! 👋',
        'नमस्कार! 👋',
        'নমস্কার! 👋',
        'নমস্কাৰ! 👋',
      );
    }

    return _text(
      language,
      'Hello, $name! 👋',
      'नमस्ते, $name! 👋',
      'नमस्कार, $name! 👋',
      'নমস্কার, $name! 👋',
      'নমস্কাৰ, $name! 👋',
    );
  }

  String _description(AppLanguage language) {
    return _text(
      language,
      'I am your voice assistant.\nTap the microphone and speak.',
      'मैं आपका वॉइस असिस्टेंट हूँ।\nमाइक्रोफ़ोन दबाएँ और बोलें।',
      'मी तुमचा व्हॉइस असिस्टंट आहे.\nमायक्रोफोन दाबा आणि बोला.',
      'আমি আপনার ভয়েস অ্যাসিস্ট্যান্ট।\nমাইক্রোফোনে চাপ দিয়ে কথা বলুন।',
      'মই আপোনাৰ ভইচ সহায়ক।\nমাইক্ৰ’ফোনত টিপি কথা কওক।',
    );
  }

  String _listeningText(AppLanguage language) {
    return _text(
      language,
      'Listening... Tap to stop',
      'सुन रहा हूँ... रोकने के लिए दबाएँ',
      'ऐकत आहे... थांबवण्यासाठी दाबा',
      'শুনছি... থামাতে চাপ দিন',
      'শুনি আছোঁ... বন্ধ কৰিবলৈ টিপক',
    );
  }

  String _tapToSpeakText(AppLanguage language) {
    return _text(
      language,
      'Tap to speak',
      'बोलने के लिए दबाएँ',
      'बोलण्यासाठी दाबा',
      'কথা বলতে চাপ দিন',
      'কথা ক’বলৈ টিপক',
    );
  }

  String _youSaidText(AppLanguage language) {
    return _text(
      language,
      'You said:',
      'आपने कहा:',
      'तुम्ही म्हणालात:',
      'আপনি বলেছেন:',
      'আপুনি ক’লে:',
    );
  }

  // ------------------------------------------------------------
  // INIT
  // ------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final language = AppLanguageController.instance.language;

    _response = _text(
      language,
      'Hello! How can I help you?',
      'नमस्ते! मैं आपकी कैसे मदद कर सकता हूँ?',
      'नमस्कार! मी तुमची कशी मदत करू शकतो?',
      'নমস্কার! আমি আপনাকে কীভাবে সাহায্য করতে পারি?',
      'নমস্কাৰ! মই আপোনাক কেনেকৈ সহায় কৰিব পাৰোঁ?',
    );

    _speak(_response);
  }

  // ------------------------------------------------------------
  // SPEAK
  // ------------------------------------------------------------

  Future<void> _speak(String text) async {
    if (!mounted) return;

    setState(() {
      _response = text;
    });

    await _audioService.speak(text);
  }

  // ------------------------------------------------------------
  // START LISTENING
  // ------------------------------------------------------------

  Future<void> _startListening() async {
    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      },
    );

    final language =
        AppLanguageController.instance.language;

    if (!available) {
      await _speak(
        _text(
          language,
          'Sorry, I cannot access the microphone right now.',
          'माफ़ कीजिए, मैं अभी माइक्रोफ़ोन का उपयोग नहीं कर सकता।',
          'माफ करा, मी सध्या मायक्रोफोन वापरू शकत नाही.',
          'দুঃখিত, আমি এখন মাইক্রোফোন ব্যবহার করতে পারছি না।',
          'ক্ষমা কৰিব, মই এতিয়া মাইক্ৰ’ফোন ব্যৱহাৰ কৰিব নোৱাৰোঁ।',
        ),
      );

      return;
    }

    setState(() {
      _isListening = true;
      _spokenText = '';
    });

    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          _spokenText = result.recognizedWords;
        });

        if (result.finalResult) {
          _handleCommand(result.recognizedWords);
        }
      },
      listenOptions: stt.SpeechListenOptions(
        localeId: _speechLocale(language),
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
      ),
    );
  }

  // ------------------------------------------------------------
  // STOP LISTENING
  // ------------------------------------------------------------

  Future<void> _stopListening() async {
    await _speech.stop();

    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  // ------------------------------------------------------------
  // HANDLE COMMAND
  // ------------------------------------------------------------

  Future<void> _handleCommand(String command) async {
    final text = command.toLowerCase().trim();
    final language =
        AppLanguageController.instance.language;

    // ----------------------------------------------------------
    // EMPTY COMMAND
    // ----------------------------------------------------------

    if (text.isEmpty) {
      await _speak(
        _text(
          language,
          'I did not hear you. Please try again.',
          'मैं आपकी बात सुन नहीं पाया। कृपया फिर से बोलें।',
          'मला तुमचं म्हणणं ऐकू आलं नाही. कृपया पुन्हा बोला.',
          'আমি আপনার কথা শুনতে পাইনি। আবার বলুন।',
          'মই আপোনাৰ কথা শুনা নাপালোঁ। অনুগ্ৰহ কৰি আকৌ কওক।',
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // WHAT IS MY NAME?
    // ----------------------------------------------------------

    if (text.contains('my name') ||
        text.contains('who am i') ||
        text.contains('name') ||
        text.contains('मेरा नाम') ||
        text.contains('नाम') ||
        text.contains('माझं नाव') ||
        text.contains('माझे नाव') ||
        text.contains('नाव') ||
        text.contains('আমার নাম') ||
        text.contains('নাম') ||
        text.contains('মোৰ নাম')) {
      final name =
          PatientNameController.instance.firstName;

      if (name.isEmpty) {
        await _speak(
          _text(
            language,
            'I do not have your name yet.',
            'मुझे अभी आपका नाम पता नहीं है।',
            'मला अजून तुमचं नाव माहीत नाही.',
            'আমি এখনও আপনার নাম জানি না।',
            'মই এতিয়াও আপোনাৰ নাম নাজানো।',
          ),
        );
      } else {
        await _speak(
          _text(
            language,
            'Your name is $name.',
            'आपका नाम $name है।',
            'तुमचं नाव $name आहे.',
            'আপনার নাম $name।',
            'আপোনাৰ নাম $name।',
          ),
        );
      }

      return;
    }

    // ----------------------------------------------------------
    // START ACTIVITY
    // ----------------------------------------------------------

    if (text.contains('start activity') ||
        text.contains('start game') ||
        text.contains('play game') ||
        text.contains('activity') ||
        text.contains('गतिविधि') ||
        text.contains('गेम') ||
        text.contains('क्रियाकलाप') ||
        text.contains('उपक्रम') ||
        text.contains('खेळ') ||
        text.contains('অ্যাক্টিভিটি') ||
        text.contains('খেলা') ||
        text.contains('কাৰ্যকলাপ') ||
        text.contains('খেল')) {
      await _speak(
        _text(
          language,
          'Sure. Let us start your memory activity.',
          'ज़रूर। चलिए आपकी याददाश्त की गतिविधि शुरू करते हैं।',
          'नक्की. चला तुमचा स्मरणशक्तीचा उपक्रम सुरू करूया.',
          'অবশ্যই। চলুন আপনার স্মৃতির কার্যকলাপ শুরু করি।',
          'নিশ্চয়। আহক আপোনাৰ স্মৃতিৰ কাৰ্যকলাপ আৰম্ভ কৰোঁ।',
        ),
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const FaceNameMatchScreen(),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // SETTINGS
    // ----------------------------------------------------------

    if (text.contains('settings') ||
        text.contains('setting') ||
        text.contains('सेटिंग') ||
        text.contains('सेटिंग्स') ||
        text.contains('सेटिंग्ज') ||
        text.contains('সেটিংস') ||
        text.contains('সেটিং') ||
        text.contains('ছেটিং')) {
      await _speak(
        _text(
          language,
          'Opening your settings.',
          'आपकी सेटिंग्स खोल रहा हूँ।',
          'तुमची सेटिंग्ज उघडत आहे.',
          'আপনার সেটিংস খুলছি।',
          'আপোনাৰ ছেটিংছ খুলি আছোঁ।',
        ),
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PatientSettingsScreen(),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // MEDICINE
    // ----------------------------------------------------------

    if (text.contains('medicine') ||
        text.contains('medicines') ||
        text.contains('medication') ||
        text.contains('दवा') ||
        text.contains('दवाई') ||
        text.contains('औषध') ||
        text.contains('औषधि') ||
        text.contains('ওষুধ') ||
        text.contains('ঔষধ')) {
      await _speak(
        _text(
          language,
          'Your medicine reminder is at 8 AM.',
          'आपकी दवा का रिमाइंडर सुबह 8 बजे है।',
          'तुमच्या औषधाचा रिमाइंडर सकाळी 8 वाजता आहे.',
          'আপনার ওষুধের রিমাইন্ডার সকাল ৮টায়।',
          'আপোনাৰ ঔষধৰ ৰিমাইণ্ডাৰ পুৱা ৮ বজাত আছে।',
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // WATER
    // ----------------------------------------------------------

    if (text.contains('water') ||
        text.contains('drink') ||
        text.contains('पानी') ||
        text.contains('जल') ||
        text.contains('पाणी') ||
        text.contains('জল') ||
        text.contains('পানি') ||
        text.contains('পানী')) {
      await _speak(
        _text(
          language,
          'Your water reminder is at 10 AM.',
          'आपका पानी पीने का रिमाइंडर सुबह 10 बजे है।',
          'तुमचा पाणी पिण्याचा रिमाइंडर सकाळी 10 वाजता आहे.',
          'আপনার জল খাওয়ার রিমাইন্ডার সকাল ১০টায়।',
          'আপোনাৰ পানী খোৱাৰ ৰিমাইণ্ডাৰ পুৱা ১০ বজাত আছে।',
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // REMINDERS
    // ----------------------------------------------------------

    if (text.contains('reminder') ||
        text.contains('reminders') ||
        text.contains('रिमाइंडर') ||
        text.contains('याद') ||
        text.contains('स्मरण') ||
        text.contains('आठवण') ||
        text.contains('রিমাইন্ডার') ||
        text.contains('মনত পেলোৱা') ||
        text.contains('সোঁৱৰাই')) {
      await _speak(
        _text(
          language,
          'You have a medicine reminder at 8 AM, '
              'a water reminder at 10 AM, '
              'and an activity reminder at 5 PM.',
          'आपकी दवा का रिमाइंडर सुबह 8 बजे, '
              'पानी का रिमाइंडर सुबह 10 बजे, '
              'और गतिविधि का रिमाइंडर शाम 5 बजे है।',
          'तुमच्या औषधाचा रिमाइंडर सकाळी 8 वाजता, '
              'पाण्याचा रिमाइंडर सकाळी 10 वाजता, '
              'आणि उपक्रमाचा रिमाइंडर संध्याकाळी 5 वाजता आहे.',
          'আপনার ওষুধের রিমাইন্ডার সকাল ৮টায়, '
              'জলের রিমাইন্ডার সকাল ১০টায়, '
              'এবং কার্যকলাপের রিমাইন্ডার বিকেল ৫টায়।',
          'আপোনাৰ ঔষধৰ ৰিমাইণ্ডাৰ পুৱা ৮ বজাত, '
              'পানীৰ ৰিমাইণ্ডাৰ পুৱা ১০ বজাত, '
              'আৰু কাৰ্যকলাপৰ ৰিমাইণ্ডাৰ আবেলি ৫ বজাত আছে।',
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // GREETING
    // ----------------------------------------------------------

    if (text.contains('hello') ||
        text.contains('hi') ||
        text.contains('good morning') ||
        text.contains('नमस्ते') ||
        text.contains('नमस्कार') ||
        text.contains('हाय') ||
        text.contains('हॅलो') ||
        text.contains('হ্যালো') ||
        text.contains('নমস্কার') ||
        text.contains('নমস্কাৰ')) {
      await _speak(
        _text(
          language,
          'Hello! I am here to help you.',
          'नमस्ते! मैं आपकी मदद करने के लिए यहाँ हूँ।',
          'नमस्कार! मी तुमची मदत करण्यासाठी इथे आहे.',
          'নমস্কার! আমি আপনাকে সাহায্য করতে এখানে আছি।',
          'নমস্কাৰ! মই আপোনাক সহায় কৰিবলৈ ইয়াত আছোঁ।',
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // FALLBACK
    // ----------------------------------------------------------

    await _speak(
      _text(
        language,
        'I am still learning that command. '
            'You can ask my name, start an activity, '
            'open settings, or ask about reminders.',
        'मैं अभी उस कमांड को सीख रहा हूँ। '
            'आप मेरा नाम पूछ सकते हैं, गतिविधि शुरू कर सकते हैं, '
            'सेटिंग्स खोल सकते हैं या रिमाइंडर पूछ सकते हैं।',
        'मला अजून तो आदेश समजायला शिकायचं आहे. '
            'तुम्ही माझं नाव विचारू शकता, उपक्रम सुरू करू शकता, '
            'सेटिंग्ज उघडू शकता किंवा रिमाइंडर विचारू शकता.',
        'আমি এখনও সেই কমান্ডটি শিখছি। '
            'আপনি আমার নাম জিজ্ঞাসা করতে পারেন, কার্যকলাপ শুরু করতে পারেন, '
            'সেটিংস খুলতে পারেন অথবা রিমাইন্ডার সম্পর্কে জিজ্ঞাসা করতে পারেন।',
        'মই এতিয়াও সেই কমাণ্ডটো শিকি আছোঁ। '
            'আপুনি মোৰ নাম সুধিব পাৰে, কাৰ্যকলাপ আৰম্ভ কৰিব পাৰে, '
            'ছেটিংছ খুলিব পাৰে বা ৰিমাইণ্ডাৰৰ বিষয়ে সুধিব পাৰে।',
      ),
    );
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  @override
  void dispose() {
    _speech.stop();
    _audioService.stop();
    super.dispose();
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguageController.instance,
      builder: (context, _) {
        final language =
            AppLanguageController.instance.language;

        final patientName =
            PatientNameController.instance.firstName;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FBF7),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textDark,
              ),
              onPressed: () =>
                  Navigator.of(context).pop(),
            ),

            title: Text(
              _screenTitle(language),
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                30,
              ),

              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ------------------------------------------------
                  // GREETING
                  // ------------------------------------------------

                  Text(
                    _greeting(language, patientName),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ------------------------------------------------
                  // DESCRIPTION
                  // ------------------------------------------------

                  Text(
                    _description(language),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.4,
                      color: AppColors.textMedium,
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ------------------------------------------------
                  // RESPONSE CARD
                  // ------------------------------------------------

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),

                    child: Column(
                      children: [
                        const Icon(
                          Icons.record_voice_over_rounded,
                          color: AppColors.primaryGreen,
                          size: 42,
                        ),

                        const SizedBox(height: 14),

                        Text(
                          _response,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 19,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------
                  // WHAT USER SAID
                  // ------------------------------------------------

                  if (_spokenText.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color:
                            AppColors.primaryGreenLight,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),

                      child: Text(
                        '${_youSaidText(language)}\n$_spokenText',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.textDark,
                          height: 1.35,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // ------------------------------------------------
                  // MICROPHONE
                  // ------------------------------------------------

                  GestureDetector(
                    onTap: _isListening
                        ? _stopListening
                        : _startListening,

                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 250),

                      width: _isListening ? 105 : 90,
                      height: _isListening ? 105 : 90,

                      decoration: BoxDecoration(
                        color: _isListening
                            ? Colors.redAccent
                            : AppColors.primaryGreen,

                        shape: BoxShape.circle,

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: 0.15,
                            ),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),

                      child: Icon(
                        _isListening
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    _isListening
                        ? _listeningText(language)
                        : _tapToSpeakText(language),

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}