// 📄 lib/web_admin/screens/super_admin_settings_web_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminSettingsWebScreen extends StatefulWidget {
  const SuperAdminSettingsWebScreen({super.key});

  @override
  State<SuperAdminSettingsWebScreen> createState() => _SuperAdminSettingsWebScreenState();
}

class _SuperAdminSettingsWebScreenState extends State<SuperAdminSettingsWebScreen> {
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController smsApiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    final doc = await FirebaseFirestore.instance.collection('settings').doc('global').get();
    if (doc.exists) {
      final data = doc.data()!;
      whatsappController.text = data['whatsappNumber'] ?? '';
      smsApiKeyController.text = data['smsApiKey'] ?? '';
    }
  }

  Future<void> saveSettings() async {
    await FirebaseFirestore.instance.collection('settings').doc('global').set({
      'whatsappNumber': whatsappController.text.trim(),
      'smsApiKey': smsApiKeyController.text.trim(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ تم حفظ الإعدادات')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ إعدادات النظام')),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('رقم واتساب للتنبيهات:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: whatsappController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('مفتاح API لخدمة SMS:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: smsApiKeyController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveSettings,
                child: const Text('💾 حفظ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
