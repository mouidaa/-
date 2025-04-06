// 📄 lib/web_admin/screens/subscriptions_web_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionsWebScreen extends StatelessWidget {
  const SubscriptionsWebScreen({super.key});

  String formatDate(Timestamp ts) {
    final date = ts.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🕓 إدارة الاشتراكات')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('subscriptions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Center(child: Text('لا توجد اشتراكات حالياً'));
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('الفندق')),
                  DataColumn(label: Text('البداية')),
                  DataColumn(label: Text('الانتهاء')),
                  DataColumn(label: Text('الحالة')),
                  DataColumn(label: Text('خيارات')),
                ],
                rows: docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final start = data['startDate'] as Timestamp;
                  final end = data['endDate'] as Timestamp;
                  final isActive = end.toDate().isAfter(DateTime.now());

                  return DataRow(cells: [
                    DataCell(Text(data['hotelName'] ?? '')),
                    DataCell(Text(formatDate(start))),
                    DataCell(Text(formatDate(end))),
                    DataCell(Text(isActive ? '✅ نشط' : '⛔ منتهي')),
                    DataCell(ElevatedButton(
                      onPressed: () {
                        // تعديل الاشتراك لاحقاً
                      },
                      child: const Text('تعديل'),
                    )),
                  ]);
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
