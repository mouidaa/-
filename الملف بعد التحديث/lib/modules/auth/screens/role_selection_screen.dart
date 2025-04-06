// lib/modules/auth/screens/role_selection_screen.dart

import 'package:flutter/material.dart';
import '../../../core/constants/route_names.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار الدور')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('مرحباً بك 👋', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            const Text('اختر نوع المستخدم لتسجيل الدخول',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.meeting_room),
              label: const Text('موظف الاستقبال'),
              onPressed: () => _navigateTo(context, RouteNames.receptionHome),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.cleaning_services),
              label: const Text('عامل النظافة'),
              onPressed: () => _navigateTo(context, RouteNames.cleaningHome),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('المشرف العام'),
              onPressed: () => _navigateTo(context, RouteNames.superAdminDashboard),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('الضيف'),
              onPressed: () => _navigateTo(context, RouteNames.guestHome),
            ),
          ],
        ),
      ),
    );
  }
}
