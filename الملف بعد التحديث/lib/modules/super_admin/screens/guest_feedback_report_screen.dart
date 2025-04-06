// lib/modules/super_admin/screens/guest_feedback_report_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestFeedbackReportScreen extends StatelessWidget {
  const GuestFeedbackReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقرير ملاحظات الضيوف')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('guest_feedback')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbackList = snapshot.data?.docs ?? [];

          if (feedbackList.isEmpty) {
            return const Center(child: Text('لا توجد ملاحظات حالياً'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: feedbackList.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final data = feedbackList[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: const Icon(Icons.comment),
                title: Text(data['guestName'] ?? 'ضيف مجهول'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الغرفة: ${data['roomNumber'] ?? 'غير محدد'}'),
                    Text(data['comment'] ?? ''),
                    if (data['timestamp'] != null)
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(
                            data['timestamp'].millisecondsSinceEpoch)
                            .toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
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
