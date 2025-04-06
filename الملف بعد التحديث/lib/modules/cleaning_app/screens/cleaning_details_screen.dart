// ✅ شاشة تفاصيل التنظيف داخل الغرفة - نظام الجرد + حفظ في Firebase

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CleaningDetailsScreen extends StatefulWidget {
  final String roomNumber;

  const CleaningDetailsScreen({super.key, required this.roomNumber});

  @override
  State<CleaningDetailsScreen> createState() => _CleaningDetailsScreenState();
}

class _CleaningDetailsScreenState extends State<CleaningDetailsScreen> {
  final List<String> expectedItems = [
    'منشفة',
    'ماء شرب',
    'شامبو',
    'صابون',
    'مخدة إضافية',
  ];

  final Set<String> missingItems = {};

  final CollectionReference missingReportsCollection =
  FirebaseFirestore.instance.collection('missing_items_reports');

  void toggleMissing(String item) {
    setState(() {
      if (missingItems.contains(item)) {
        missingItems.remove(item);
      } else {
        missingItems.add(item);
      }
    });
  }

  Future<void> submitReport() async {
    if (missingItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ لا توجد نواقص')),
      );
      return;
    }

    try {
      await missingReportsCollection.add({
        'roomNumber': widget.roomNumber,
        'missingItems': missingItems.toList(),
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🚨 تم إرسال تقرير النواقص إلى Firebase')),
      );

      setState(() {
        missingItems.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ فشل في حفظ التقرير: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('جرد غرفة ${widget.roomNumber}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('حدد الأصناف الناقصة:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: expectedItems.length,
                itemBuilder: (context, index) {
                  final item = expectedItems[index];
                  return CheckboxListTile(
                    title: Text(item),
                    value: missingItems.contains(item),
                    onChanged: (_) => toggleMissing(item),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: submitReport,
                child: const Text('إرسال تقرير النواقص'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}