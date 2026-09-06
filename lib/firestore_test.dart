import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  static Future<void> testConnection() async {
    try {
      await FirebaseFirestore.instance
          .collection('test')
          .doc('connection')
          .set({
        'message': 'YaadSaathi Firebase connected!',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('🔥 FIRESTORE CONNECTED SUCCESSFULLY');
    } catch (e) {
      print('❌ FIRESTORE ERROR: $e');
    }
  }
}