// lib/modules/admin_app/screens/bookings_report_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingsReportScreen extends StatelessWidget {
  const BookingsReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقرير الحجوزات')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').orderBy('checkInDate', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد حجوزات حالياً'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.separated(
            itemCount: bookings.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final data = bookings[index].data() as Map<String, dynamic>;
              final checkIn = (data['checkInDate'] as Timestamp?)?.toDate();
              final checkOut = (data['checkOutDate'] as Timestamp?)?.toDate();

              return ListTile(
                leading: const Icon(Icons.hotel),
                title: Text('الغرفة: ${data['roomNumber'] ?? 'غير معروف'}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العميل: ${data['customerName'] ?? ''}'),
                    Text('الوصول: ${checkIn != null ? DateFormat('yyyy-MM-dd').format(checkIn) : '---'}'),
                    Text('المغادرة: ${checkOut != null ? DateFormat('yyyy-MM-dd').format(checkOut) : '---'}'),
                    Text('الدفع: ${data['paymentMethod'] ?? ''}'),
                    Text('الحالة: ${data['status'] ?? ''}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
