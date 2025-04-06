import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'super_admin_settings_web_screen.dart';
import 'subscriptions_web_screen.dart';

class SuperDashboardWebScreen extends StatelessWidget {
  const SuperDashboardWebScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المالك - Web'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 إحصائيات اليوم ($today):',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: const [
                _StatCard(title: 'عدد الفنادق', count: 12, icon: Icons.apartment),
                _StatCard(title: 'عدد الحجوزات', count: 97, icon: Icons.book_online),
                _StatCard(title: 'طلبات التنظيف', count: 23, icon: Icons.cleaning_services),
                _StatCard(title: 'الضيوف', count: 78, icon: Icons.people),
              ],
            ),
            const SizedBox(height: 32),
            const Text('🛠️ التحكم العام:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuperAdminSettingsWebScreen()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('إعدادات النظام'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                  icon: const Icon(Icons.monetization_on),
                  label: const Text('روابط الدفع'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SubscriptionsWebScreen()),
                    );
                  },
                  icon: const Icon(Icons.list_alt),
                  label: const Text('إدارة الاشتراكات'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Placeholder()),
                    );
                  },
                  icon: const Icon(Icons.star_rate),
                  label: const Text('تقييمات الضيوف'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const _StatCard({required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text('$count', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
