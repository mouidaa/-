import 'package:flutter/material.dart';
import '../../../core/constants/route_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الاستقبال')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildNavButton(context, 'إجراء حجز جديد', RouteNames.booking),
            _buildNavButton(context, 'قائمة الحجوزات', RouteNames.bookingsList),
            _buildNavButton(context, 'البحث في الحجوزات', RouteNames.filteredBookings),
            _buildNavButton(context, 'طلبات التنظيف', RouteNames.cleaningHome),
            _buildNavButton(context, 'طلبات الخدمة', RouteNames.serviceRequest),
            _buildNavButton(context, 'لوحة المدير', RouteNames.adminDashboard),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
