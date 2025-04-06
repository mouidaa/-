import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getDashboardStats() async {
    try {
      final hotelsSnapshot = await _firestore.collection('hotels').get();
      final bookingsSnapshot = await _firestore.collection('bookings').get();
      final cleaningSnapshot = await _firestore.collection('cleaning_requests').get();
      final usersSnapshot = await _firestore.collection('users').get();

      int guestsCount = usersSnapshot.docs
          .where((doc) => (doc.data()['role'] ?? '') == 'guest')
          .length;

      return {
        'hotels': hotelsSnapshot.size,
        'bookings': bookingsSnapshot.size,
        'cleaning': cleaningSnapshot.size,
        'guests': guestsCount,
      };
    } catch (e) {
      print('❌ Error fetching stats: $e');
      return {
        'hotels': 0,
        'bookings': 0,
        'cleaning': 0,
        'guests': 0,
      };
    }
  }
}
