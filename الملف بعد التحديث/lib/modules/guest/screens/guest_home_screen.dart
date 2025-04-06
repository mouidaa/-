import 'package:flutter/material.dart';
import 'guest_booking_lookup_screen.dart';
import 'guest_feedback_screen.dart';

class GuestHomeScreen extends StatelessWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الضيف - مرحبًا بك')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GuestBookingLookupScreen()),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('🔍 استعراض الحجز'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GuestFeedbackScreen()),
                );
              },
              icon: const Icon(Icons.rate_review),
              label: const Text('⭐ إرسال تقييم أو ملاحظة'),
            ),
          ],
        ),
      ),
    );
  }
}
