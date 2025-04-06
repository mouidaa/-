// lib/modules/super_admin/screens/super_admin_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuperAdminSettingsScreen extends StatelessWidget {
  const SuperAdminSettingsScreen({super.key});

  void _resetAllBookings(BuildContext context) async {
    final bookings = await FirebaseFirestore.instance.collection('bookings').get();

    for (var doc in bookings.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف جميع الحجوزات')),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف جميع الحجوزات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAllBookings(context);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void _updateSystemInfo() {
    // سيتم ربطه لاحقًا بواجهة Firebase لتحديث اسم النظام أو الشعار
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات المشرف العام')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'خيارات النظام',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('تحديث معلومات النظام'),
            onPressed: _updateSystemInfo,
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'إدارة البيانات',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever),
            label: const Text('حذف جميع الحجوزات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => _showConfirmDialog(context),
          ),
        ],
      ),
    );
  }
}
