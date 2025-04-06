import 'package:flutter/material.dart';

class ServiceRequestsScreen extends StatelessWidget {
  const ServiceRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الخدمة'),
      ),
      body: ListView.builder(
        itemCount: 10, // عدد الطلبات
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('طلب الخدمة رقم $index'),
            subtitle: const Text('وصف الخدمة المطلوبة'),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                // قم بتغيير حالة الطلب إلى "مكتمل"
              },
            ),
          );
        },
      ),
    );
  }
}
