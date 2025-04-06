import 'package:flutter/material.dart';

class CleanerScreen extends StatelessWidget {
  const CleanerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('موظف النظافة'),
      ),
      body: ListView.builder(
        itemCount: 5, // عدد الغرف التي بحاجة تنظيف
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('غرفة رقم ${index + 1}'),
            subtitle: const Text('بحاجة تنظيف'),
            trailing: IconButton(
              icon: const Icon(Icons.check_circle),
              onPressed: () {
                // تحديث حالة الغرفة
              },
            ),
          );
        },
      ),
    );
  }
}
