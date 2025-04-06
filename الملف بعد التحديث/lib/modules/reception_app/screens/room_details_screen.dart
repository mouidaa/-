// lib/modules/reception_app/screens/room_details_screen.dart

import 'package:flutter/material.dart';

class RoomDetailsScreen extends StatelessWidget {
  final String roomNumber;
  final String roomStatus;
  final List<String> items;

  const RoomDetailsScreen({
    super.key,
    required this.roomNumber,
    required this.roomStatus,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الغرفة $roomNumber'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('حالة الغرفة: $roomStatus',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text(
              'الأصناف داخل الغرفة:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.check),
                  title: Text(items[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
