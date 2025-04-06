// lib/modules/reception_app/screens/service_request_screen.dart

import 'package:flutter/material.dart';
import '../../../services/firebase_service.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  final TextEditingController _requestController = TextEditingController();
  bool isSending = false;

  Future<void> _submitRequest() async {
    final content = _requestController.text.trim();
    if (content.isEmpty) return;

    setState(() => isSending = true);
    await FirebaseService.sendServiceRequest(content);
    setState(() {
      isSending = false;
      _requestController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طلب خدمة')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'اكتب تفاصيل الطلب الذي ترغب في إرساله إلى الإدارة:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _requestController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'مثال: صيانة المكيف في الغرفة 202',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isSending ? null : _submitRequest,
              icon: const Icon(Icons.send),
              label: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }
}
