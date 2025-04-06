// lib/modules/reception_app/screens/bookings_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/route_names.dart';
import '../../../modules/models/booking_model.dart';
import '../../../services/firebase_service.dart';
import 'booking_details_screen.dart';

class BookingsListScreen extends StatefulWidget {
  const BookingsListScreen({super.key});

  @override
  State<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  late Future<List<BookingModel>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = FirebaseService.fetchBookings();
  }

  void refreshData() {
    setState(() {
      bookingsFuture = FirebaseService.fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الحجوزات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refreshData,
          )
        ],
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء تحميل البيانات'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد حجوزات حالياً'));
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text('الغرفة ${booking.roomNumber}'),
                subtitle: Text(
                  'العميل: ${booking.customerName}\n'
                      'الوصول: ${DateFormat('yyyy-MM-dd').format(booking.checkInDate)}\n'
                      'المغادرة: ${DateFormat('yyyy-MM-dd').format(booking.checkOutDate)}',
                ),
                trailing: Text(booking.status),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetailsScreen(booking: booking),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
