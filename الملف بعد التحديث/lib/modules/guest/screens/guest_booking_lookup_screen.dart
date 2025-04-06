// lib/modules/guest_app/screens/guest_booking_lookup_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestBookingLookupScreen extends StatefulWidget {
  const GuestBookingLookupScreen({super.key});

  @override
  State<GuestBookingLookupScreen> createState() => _GuestBookingLookupScreenState();
}

class _GuestBookingLookupScreenState extends State<GuestBookingLookupScreen> {
  final TextEditingController _phoneController = TextEditingController();
  List<DocumentSnapshot> _results = [];
  bool _loading = false;

  void _searchBooking() async {
    setState(() => _loading = true);
    final query = await FirebaseFirestore.instance
        .collection('bookings')
        .where('phoneNumber', isEqualTo: _phoneController.text.trim())
        .get();

    setState(() {
      _results = query.docs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحقق من الحجز')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'رقم الجوال',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _searchBooking,
              child: const Text('بحث'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading && _results.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final data = _results[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text('الغرفة: ${data['roomNumber'] ?? ''}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('العميل: ${data['customerName'] ?? ''}'),
                          Text('الدفع: ${data['paymentMethod'] ?? ''}'),
                          Text('الحالة: ${data['status'] ?? ''}'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (!_loading && _results.isEmpty && _phoneController.text.isNotEmpty)
              const Text('لا توجد حجوزات لهذا الرقم'),
          ],
        ),
      ),
    );
  }
}
