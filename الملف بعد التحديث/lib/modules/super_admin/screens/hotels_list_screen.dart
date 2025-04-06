import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelsListScreen extends StatelessWidget {
  const HotelsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الفنادق')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد فنادق مسجلة حالياً'));
          }

          final hotels = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index].data() as Map<String, dynamic>;
              final name = hotel['name'] ?? 'بدون اسم';
              final city = hotel['city'] ?? 'غير محددة';
              final id = hotels[index].id;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('📍 المدينة: $city'),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      // الانتقال لشاشة تفاصيل الفندق لاحقًا
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم الضغط على فندق ID: $id')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
