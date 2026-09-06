import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/services/sync_service.dart';
import '../../../core/state/patient_name_controller.dart';

class CaregiverDashboardController extends ChangeNotifier {
  CaregiverDashboardController({
    this.patientId,
  });

  /// This must come from authentication/backend/navigation.
  ///
  /// It is intentionally nullable so the app never falls back to a
  /// fake patient identifier.
  final String? patientId;

  String get patientName =>
      PatientNameController.instance.name.trim();

  String get patientFirstName =>
      PatientNameController.instance.firstName.trim();

  Stream<QuerySnapshot<Map<String, dynamic>>>? get gameSessionsStream {
    final id = patientId?.trim();

    if (id == null || id.isEmpty) {
      return null;
    }

    return SyncService.gameSessionsStream(
      patientId: id,
    );
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> todaySessions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final now = DateTime.now();

    return sessions.where((document) {
      final data = document.data();
      final timestamp = _readDate(data);

      if (timestamp == null) {
        return false;
      }

      return timestamp.year == now.year &&
          timestamp.month == now.month &&
          timestamp.day == now.day;
    }).toList();
  }

  int completedActivities(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    return sessions.length;
  }

  int faceCorrectAnswers(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final faceSessions = sessions.where(
      (document) =>
          document.data()['gameType']?.toString() == 'face_name_match',
    );

    return faceSessions.fold<int>(
      0,
      (total, document) =>
          total + _readInt(document.data()['correctAnswers']),
    );
  }

  int faceTotalQuestions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final faceSessions = sessions.where(
      (document) =>
          document.data()['gameType']?.toString() == 'face_name_match',
    );

    return faceSessions.fold<int>(
      0,
      (total, document) =>
          total + _readInt(document.data()['totalQuestions']),
    );
  }

  double faceAccuracy(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final total = faceTotalQuestions(sessions);

    if (total == 0) {
      return 0;
    }

    final correct = faceCorrectAnswers(sessions);

    return (correct / total).clamp(0.0, 1.0);
  }

  String? latestGameType(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    if (sessions.isEmpty) {
      return null;
    }

    final sorted = [...sessions]
      ..sort((a, b) {
        final first = _readDate(a.data());
        final second = _readDate(b.data());

        if (first == null && second == null) return 0;
        if (first == null) return 1;
        if (second == null) return -1;

        return second.compareTo(first);
      });

    return sorted.first.data()['gameType']?.toString();
  }

  DateTime? _readDate(Map<String, dynamic> data) {
    final value = data['completedAt'] ?? data['createdAt'];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  int _readInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}