import 'package:flutter/material.dart';
import '../../../modules/models/booking_model.dart';
import '../../../services/firebase_service.dart';

class CleaningHomeScreen extends StatefulWidget {
  const CleaningHomeScreen({super.key});

  @override
  State<CleaningHomeScreen> createState() => _CleaningHomeScreenState();
}

class _CleaningHomeScreenState extends State<CleaningHomeScreen> {
  late Future<List<BookingModel>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = FirebaseService.fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنظيف الغرف')),
      body: FutureBuilder<List<BookingModel>>(
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد حجوزات حالياً.'));
          } else {
            final dirtyRooms = snapshot.data!
                .where((b) => b.status == 'بانتظار التنظيف')
                .toList();

            return dirtyRooms.isEmpty
                ? const Center(child: Text('لا توجد غرف بحاجة تنظيف.'))
                : ListView.builder(
              itemCount: dirtyRooms.length,
              itemBuilder: (context, index) {
                final booking = dirtyRooms[index];
                return ListTile(
                  title: Text('الغرفة ${booking.roomNumber}'),
                  subtitle: Text('العميل: ${booking.customerName}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // تغيير الحالة إلى "تم التنظيف"
                      FirebaseService.updateBookingStatus(
                        booking.roomNumber,
                        'تم التنظيف',
                      );
                      setState(() {
                        bookingsFuture = FirebaseService.fetchBookings();
                      });
                    },
                    child: const Text('تم التنظيف'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
