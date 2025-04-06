// lib/services/firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../modules/models/booking_model.dart';

class FirebaseService {
  static final _firestore = FirebaseFirestore.instance;
  static final _bookingsCollection = _firestore.collection('bookings');

  /// إضافة حجز جديد
  static Future<void> addBooking(BookingModel booking) async {
    await _bookingsCollection.add(booking.toMap());
  }

  /// جلب جميع الحجوزات
  static Future<List<BookingModel>> fetchBookings() async {
    final querySnapshot = await _bookingsCollection.get();
    return querySnapshot.docs.map((doc) {
      return BookingModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  /// تحديث حالة الحجز
  static Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await _bookingsCollection.doc(bookingId).update({'status': newStatus});
  }

  static Future<void> sendServiceRequest(String content) async {
    await FirebaseFirestore.instance.collection('service_requests').add({
      'message': content,
      'timestamp': Timestamp.now(),
    });
  }
  static Future<List<BookingModel>> fetchBookingsByStatus(String status) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('bookings')
        .where('status', isEqualTo: status)
        .get();

    return snapshot.docs.map((doc) => BookingModel.fromMap(doc.data(), doc.id)).toList();
  }

  /// تحديث بيانات كاملة للحجز
  static Future<void> updateBooking(String bookingId, Map<String, dynamic> updatedData) async {
    await _bookingsCollection.doc(bookingId).update(updatedData);
  }

  /// حذف حجز
  static Future<void> deleteBooking(String bookingId) async {
    await _bookingsCollection.doc(bookingId).delete();
  }
}
