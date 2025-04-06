import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stayin_hub3/modules/models/booking_model.dart';

class ApiService {
  final CollectionReference bookingsCollection =
  FirebaseFirestore.instance.collection('bookings');

  final CollectionReference cleaningCollection =
  FirebaseFirestore.instance.collection('cleaning_requests'); // ✅ تنظيف

  Future<void> addBooking(BookingModel booking) async {
    try {
      await bookingsCollection.doc(booking.id).set(booking.toMap());
      print('✅ تم حفظ الحجز بنجاح');
    } catch (e) {
      print('❌ فشل في حفظ الحجز: $e');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchBookings() async {
    try {
      QuerySnapshot snapshot = await bookingsCollection.get();
      return snapshot.docs.map((doc) {
        return BookingModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('❌ خطأ في جلب البيانات: $e');
      return [];
    }
  }

  Future<void> updateBooking(BookingModel booking) async {
    try {
      await bookingsCollection.doc(booking.id).update(booking.toMap());
      print('✅ تم تحديث الحجز');
    } catch (e) {
      print('❌ خطأ في التحديث: $e');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    try {
      await bookingsCollection.doc(bookingId).delete();
      print('✅ تم حذف الحجز');
    } catch (e) {
      print('❌ خطأ في الحذف: $e');
    }
  }

  // ✅ إضافة طلب تنظيف بعد الحجز
  Future<void> createCleaningRequest({required String bookingId, required String roomNumber}) async {
    try {
      await cleaningCollection.doc(bookingId).set({
        'bookingId': bookingId,
        'roomNumber': roomNumber,
        'status': 'قيد التنظيف',
      });
      print('🚿 تم إنشاء طلب التنظيف');
    } catch (e) {
      print('❌ خطأ في إنشاء طلب التنظيف: $e');
    }
  }
}
