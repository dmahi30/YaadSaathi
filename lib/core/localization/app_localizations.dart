import 'app_language.dart';
import 'app_language_controller.dart';

import 'languages/english.dart';
import 'languages/hindi.dart';
import 'languages/marathi.dart';
import 'languages/bengali.dart';
import 'languages/assamese.dart';

class AppLocalizations {
  final String appName;
  final String tagline;
  final String welcomeDescription;
  final String getStarted;
  final String chooseYourLanguage;
  final String tapToSelect;
  final String confirmLanguage;

  final String setupProfileTitle;
  final String setupProfileDescription;
  final String name;
  final String dateOfBirth;
  final String preferredLanguage;
  final String continueText;
  final String photoUploadComingSoon;

  final String goodMorning;
  final String memoryActivity;
  final String memoryCircle;
  final String reminders;
  final String home;
  final String activities;
  final String profile;
  final String noReminders;

  final String whoIsThis;
  final String greatJob;
  final String next;
  final String playAgain;
  final String correct;
  final String wrong;
  final String tryAgain;
  final String tapCorrectName;
  final String seeResult;

  final String greatEffort;
  final String remembered;
  final String score;
  final String correctAnswers;
  final String backHome;

  final String yes;
  final String no;
  final String cancel;
  final String save;
  final String back;

  final String matchFamiliarFaces;
  final String peopleVoicesMemories;
  final String voice;
  final String voiceAssistantComingSoon;
  final String settings;

  final String peopleYouLove;
  final String tapPersonToRemember;
  final String hearMessage;

  // Settings
  final String textSize;
  final String display;
  final String language;
  final String caregiverAccess;
  final String callCaregiver;
  final String privacyHelp;
  final String aboutYaadSaathi;

  // Patient Home
  final String online;
  final String todaysMemoryActivity;
  final String startActivity;
  final String medicine;
  final String water;
  final String activity;
  final String appointment;
  final String tomorrow;

  final String Function(String id) familyMemberName;

  AppLocalizations({
    required this.appName,
    required this.tagline,
    required this.welcomeDescription,
    required this.getStarted,
    required this.chooseYourLanguage,
    required this.tapToSelect,
    required this.confirmLanguage,
    required this.setupProfileTitle,
    required this.setupProfileDescription,
    required this.name,
    required this.dateOfBirth,
    required this.preferredLanguage,
    required this.continueText,
    required this.photoUploadComingSoon,
    required this.goodMorning,
    required this.memoryActivity,
    required this.memoryCircle,
    required this.reminders,
    required this.home,
    required this.activities,
    required this.profile,
    required this.noReminders,
    required this.whoIsThis,
    required this.greatJob,
    required this.next,
    required this.playAgain,
    required this.correct,
    required this.wrong,
    required this.tryAgain,
    required this.tapCorrectName,
    required this.seeResult,
    required this.greatEffort,
    required this.remembered,
    required this.score,
    required this.correctAnswers,
    required this.backHome,
    required this.yes,
    required this.no,
    required this.cancel,
    required this.save,
    required this.back,
    required this.matchFamiliarFaces,
    required this.peopleVoicesMemories,
    required this.voice,
    required this.voiceAssistantComingSoon,
    required this.settings,
    required this.peopleYouLove,
    required this.tapPersonToRemember,
    required this.hearMessage,
    required this.textSize,
    required this.display,
    required this.language,
    required this.caregiverAccess,
    required this.callCaregiver,
    required this.privacyHelp,
    required this.aboutYaadSaathi,
    required this.online,
    required this.todaysMemoryActivity,
    required this.startActivity,
    required this.medicine,
    required this.water,
    required this.activity,
    required this.appointment,
    required this.tomorrow,
    required this.familyMemberName,
  });

  factory AppLocalizations.fromMap(
    Map<String, String> map,
    Map<String, String> familyNames,
  ) {
    return AppLocalizations(
      appName: map['appName']!,
      tagline: map['tagline']!,
      welcomeDescription: map['welcomeDescription']!,
      getStarted: map['getStarted']!,
      chooseYourLanguage: map['chooseYourLanguage']!,
      tapToSelect: map['tapToSelect']!,
      confirmLanguage: map['confirmLanguage']!,
      setupProfileTitle: map['setupProfileTitle']!,
      setupProfileDescription: map['setupProfileDescription']!,
      name: map['name']!,
      dateOfBirth: map['dateOfBirth']!,
      preferredLanguage: map['preferredLanguage']!,
      continueText: map['continueText']!,
      photoUploadComingSoon: map['photoUploadComingSoon']!,
      goodMorning: map['goodMorning']!,
      memoryActivity: map['memoryActivity']!,
      memoryCircle: map['memoryCircle']!,
      reminders: map['reminders']!,
      home: map['home']!,
      activities: map['activities']!,
      profile: map['profile']!,
      noReminders: map['noReminders']!,
      whoIsThis: map['whoIsThis']!,
      greatJob: map['greatJob']!,
      next: map['next']!,
      playAgain: map['playAgain']!,
      correct: map['correct']!,
      wrong: map['wrong']!,
      tryAgain: map['tryAgain']!,
      tapCorrectName: map['tapCorrectName']!,
      seeResult: map['seeResult']!,
      greatEffort: map['greatEffort']!,
      remembered: map['remembered']!,
      score: map['score']!,
      correctAnswers: map['correctAnswers']!,
      backHome: map['backHome']!,
      yes: map['yes']!,
      no: map['no']!,
      cancel: map['cancel']!,
      save: map['save']!,
      back: map['back']!,
      matchFamiliarFaces: map['matchFamiliarFaces']!,
      peopleVoicesMemories: map['peopleVoicesMemories']!,
      voice: map['voice']!,
      voiceAssistantComingSoon: map['voiceAssistantComingSoon']!,
      settings: map['settings']!,
      peopleYouLove: map['peopleYouLove']!,
      tapPersonToRemember: map['tapPersonToRemember']!,
      hearMessage: map['hearMessage']!,
      textSize: map['textSize']!,
      display: map['display']!,
      language: map['language']!,
      caregiverAccess: map['caregiverAccess']!,
      callCaregiver: map['callCaregiver']!,
      privacyHelp: map['privacyHelp']!,
      aboutYaadSaathi: map['aboutYaadSaathi']!,
      online: map['online']!,
      todaysMemoryActivity: map['todaysMemoryActivity']!,
      startActivity: map['startActivity']!,
      medicine: map['medicine']!,
      water: map['water']!,
      activity: map['activity']!,
      appointment: map['appointment']!,
      tomorrow: map['tomorrow']!,
      familyMemberName: (id) => familyNames[id] ?? id,
    );
  }

  static final Map<String, String> _englishFamilyNames = {
    'meera': 'Meera',
    'rahul': 'Rahul',
    'asha': 'Asha',
    'arun': 'Arun',
    'dadi': 'Dadi',
  };

  static final Map<String, String> _hindiFamilyNames = {
    'meera': 'मीरा',
    'rahul': 'राहुल',
    'asha': 'आशा',
    'arun': 'अरुण',
    'dadi': 'दादी',
  };

  static final Map<String, String> _marathiFamilyNames = {
    'meera': 'मीरा',
    'rahul': 'राहुल',
    'asha': 'आशा',
    'arun': 'अरुण',
    'dadi': 'आजी',
  };

  static final Map<String, String> _bengaliFamilyNames = {
    'meera': 'মীরা',
    'rahul': 'রাহুল',
    'asha': 'আশা',
    'arun': 'অরুণ',
    'dadi': 'দিদা',
  };

  static final Map<String, String> _assameseFamilyNames = {
    'meera': 'মীৰা',
    'rahul': 'ৰাহুল',
    'asha': 'আশা',
    'arun': 'অৰুণ',
    'dadi': 'আইতা',
  };

  static final AppLocalizations _english = AppLocalizations.fromMap(
    english,
    _englishFamilyNames,
  );

  static final AppLocalizations _hindi = AppLocalizations.fromMap(
    hindi,
    _hindiFamilyNames,
  );

  static final AppLocalizations _marathi = AppLocalizations.fromMap(
    marathi,
    _marathiFamilyNames,
  );

  static final AppLocalizations _bengali = AppLocalizations.fromMap(
    bengali,
    _bengaliFamilyNames,
  );

  static final AppLocalizations _assamese = AppLocalizations.fromMap(
    assamese,
    _assameseFamilyNames,
  );

  static AppLocalizations of(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return _hindi;
      case AppLanguage.marathi:
        return _marathi;
      case AppLanguage.bengali:
        return _bengali;
      case AppLanguage.assamese:
        return _assamese;
      case AppLanguage.english:
        return _english;
    }
  }

  static AppLocalizations current() {
    return of(AppLanguageController.instance.language);
  }
}