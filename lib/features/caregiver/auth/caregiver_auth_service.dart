import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaregiverAuthService {
  CaregiverAuthService._();

  static final CaregiverAuthService instance = CaregiverAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Converts a normal Indian 10-digit number into Firebase's
  /// E.164 format. Numbers already starting with + are preserved.
  String normalizePhoneNumber(String input) {
    String phone = input.trim().replaceAll(RegExp(r'[\s-]'), '');

    if (phone.startsWith('+')) {
      return phone;
    }

    if (phone.startsWith('0') && phone.length == 11) {
      phone = phone.substring(1);
    }

    if (phone.length == 10) {
      return '+91$phone';
    }

    return phone;
  }

  /// Starts Firebase's real SMS verification process.
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken)
        onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(PhoneAuthCredential credential)
        onVerificationCompleted,
    int? forceResendingToken,
  }) async {
    final auth = _auth;

    await auth.verifyPhoneNumber(
      phoneNumber: normalizePhoneNumber(phoneNumber),
      timeout: const Duration(seconds: 60),
      forceResendingToken: forceResendingToken,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Verifies the SMS code entered by the user and signs them into
  /// Firebase Authentication.
  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _auth.signInWithCredential(credential);
  }

  String hashPin(String pin, String uid) {
    final bytes = utf8.encode('$uid:$pin');
    return sha256.convert(bytes).toString();
  }

  Future<void> saveCaregiverAndPatient({
    required String fullName,
    required String phoneNumber,
    required String relationshipKey,
    required String preferredLanguage,
    required String pin,
    required bool termsAccepted,
    required bool dataUseAccepted,
    required String patientName,
    required DateTime patientDob,
    required String patientLanguage,
    String patientId = 'patient_001',
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'The caregiver is not authenticated.',
      );
    }

    final uid = user.uid;
    final now = FieldValue.serverTimestamp();

    final caregiverRef = _firestore
        .collection('caregivers')
        .doc(uid);

    final patientRef = _firestore
        .collection('patients')
        .doc(patientId);

    final pinHash = hashPin(pin, uid);

    final batch = _firestore.batch();

    batch.set(
      caregiverRef,
      {
        'uid': uid,
        'fullName': fullName,
        'phoneNumber': normalizePhoneNumber(phoneNumber),
        'relationshipKey': relationshipKey,
        'preferredLanguage': preferredLanguage,
        'pinHash': pinHash,
        'termsAccepted': termsAccepted,
        'dataUseAccepted': dataUseAccepted,
        'patientId': patientId,
        'createdAt': now,
        'updatedAt': now,
      },
      SetOptions(merge: true),
    );

    batch.set(
      patientRef,
      {
        'patientId': patientId,
        'name': patientName,
        'dateOfBirth': Timestamp.fromDate(patientDob),
        'preferredLanguage': patientLanguage,
        'caregiverIds': FieldValue.arrayUnion([uid]),
        'updatedAt': now,
      },
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  Future<bool> verifyPinForCurrentUser(String pin) async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final snapshot = await _firestore
        .collection('caregivers')
        .doc(user.uid)
        .get();

    if (!snapshot.exists) {
      return false;
    }

    final data = snapshot.data();

    if (data == null) {
      return false;
    }

    final storedHash = data['pinHash'];

    if (storedHash is! String || storedHash.isEmpty) {
      return false;
    }

    final enteredHash = hashPin(pin, user.uid);

    return enteredHash == storedHash;
  }

  Future<bool> caregiverProfileExists() async {
    final user = _auth.currentUser;

    if (user == null) {
      return false;
    }

    final snapshot = await _firestore
        .collection('caregivers')
        .doc(user.uid)
        .get();

    return snapshot.exists;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  FirebaseAuth get auth => _auth;
}