import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PaymentLinksScreen extends StatelessWidget {
  const PaymentLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelsRef = FirebaseFirestore.instance.collection('hotels');

    return Scaffold(
      appBar: AppBar(title: const Text('روابط الدفع للفنادق')),
      body: StreamBuilder<QuerySnapshot>(
        stream: hotelsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد فنادق حالياً'));
          }

          final hotels = snapshot.data!.docs;

          return ListView.builder(
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final doc = hotels[index];
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'فندق غير معروف';
              final paymentLink = data['paymentLink'] ?? '';

              final controller = TextEditingController(text: paymentLink);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controller,
                        decoration: const InputDecoration(labelText: 'رابط الدفع'),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await doc.reference.update({
                                'paymentLink': controller.text.trim(),
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('✅ تم حفظ الرابط')),
                              );
                            },
                            child: const Text('💾 حفظ'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: controller.text.trim()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('📋 تم نسخ الرابط')),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                            child: const Text('نسخ'),
                          ),
                        ],
                      )
                    ],
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
