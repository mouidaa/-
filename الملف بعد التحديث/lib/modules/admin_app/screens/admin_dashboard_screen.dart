// lib/modules/admin_app/screens/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import '../../../services/firebase_service.dart';
import '../../models/booking_model.dart';
import '../../reception_app/screens/booking_details_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<BookingModel>> bookingsFuture;

  @override
  void initState() {
    super.initState();
    bookingsFuture = FirebaseService.fetchBookings();
  }

  int countByStatus(List<BookingModel> bookings, String status) {
    return bookings.where((b) => b.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المسؤول')),
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
          final confirmed = countByStatus(bookings, 'تم التأكيد');
          final canceled = countByStatus(bookings, 'تم الإلغاء');
          final pending = countByStatus(bookings, 'قيد الانتظار');

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatTile('الحجوزات المؤكدة', confirmed, Colors.green),
                _buildStatTile('الحجوزات الملغاة', canceled, Colors.red),
                _buildStatTile('قيد الانتظار', pending, Colors.orange),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return ListTile(
                        title: Text(booking.customerName),
                        subtitle: Text('الغرفة: ${booking.roomNumber}'),
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatTile(String label, int count, Color color) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}
