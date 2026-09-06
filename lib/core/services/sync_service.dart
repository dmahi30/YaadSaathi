import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/game_session.dart';

class SyncService {
  SyncService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// Saves a completed game session to Firestore.
  static Future<void> saveGameSession({
    required String patientId,
    required String gameType,
    required GameSession session,
  }) async {
    try {
      await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('game_sessions')
          .add({
        'gameType': gameType,
        'totalQuestions': session.totalQuestions,
        'correctAnswers': session.correctAnswers,
        'scorePercent': session.scorePercent,
        'completedAt': Timestamp.fromDate(session.completedAt),
      });

      print('🔥 Game session synced successfully');
    } catch (e) {
      print('❌ Failed to sync game session: $e');
    }
  }

  /// Gets all game sessions for a patient.
  static Stream<QuerySnapshot<Map<String, dynamic>>> gameSessionsStream({
    required String patientId,
  }) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('game_sessions')
        .orderBy('completedAt', descending: true)
        .snapshots();
  }
}