// lib/modules/reception_app/screens/filtered_bookings_screen.dart

import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../../services/firebase_service.dart';
import 'booking_details_screen.dart';

class FilteredBookingsScreen extends StatefulWidget {
  final String status; // مثل "تم الحجز" أو "تم الإلغاء" أو غيرها

  const FilteredBookingsScreen({super.key, required this.status});

  @override
  State<FilteredBookingsScreen> createState() => _FilteredBookingsScreenState();
}

class _FilteredBookingsScreenState extends State<FilteredBookingsScreen> {
  late Future<List<BookingModel>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = FirebaseService.fetchBookingsByStatus(widget.status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الحجوزات (${widget.status})')),
      body: FutureBuilder<List<BookingModel>>(
        future: bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد حجوزات حالياً'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return ListTile(
                title: Text(booking.customerName),
                subtitle: Text('غرفة: ${booking.roomNumber}'),
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
