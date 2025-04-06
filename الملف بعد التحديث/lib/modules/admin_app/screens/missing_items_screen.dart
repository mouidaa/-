// lib/modules/admin_app/screens/missing_items_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MissingItemsScreen extends StatelessWidget {
  const MissingItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العناصر الناقصة')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('missing_items').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد بلاغات حالياً'));
          }

          final items = snapshot.data!.docs;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final data = items[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('الغرفة: ${data['roomNumber'] ?? 'غير معروف'}'),
                  subtitle: Text('العنصر: ${data['itemName'] ?? 'غير معروف'}'),
                  trailing: Text(data['reportedBy'] ?? 'موظف غير معروف'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
