import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/overview_card.dart';
import '../services/super_admin_service.dart';
import 'guest_feedback_report_screen.dart';
import 'subscriptions_screen.dart';
import 'payment_links_screen.dart';
import 'super_admin_settings_screen.dart';
import 'hotels_list_screen.dart';

class SuperDashboardScreen extends StatefulWidget {
  const SuperDashboardScreen({super.key});

  @override
  State<SuperDashboardScreen> createState() => _SuperDashboardScreenState();
}

class _SuperDashboardScreenState extends State<SuperDashboardScreen> {
  int totalHotels = 0;
  int totalBookings = 0;
  int totalCleaning = 0;
  int totalGuests = 0;

  final SuperAdminService service = SuperAdminService();

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final stats = await service.getDashboardStats();
    setState(() {
      totalHotels = stats['hotels'] ?? 0;
      totalBookings = stats['bookings'] ?? 0;
      totalCleaning = stats['cleaning'] ?? 0;
      totalGuests = stats['guests'] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحكم المالك')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('📊 إحصائيات اليوم (${DateFormat('yyyy-MM-dd').format(DateTime.now())}):',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              Text('📅 إجمالي الحجوزات: $totalBookings'),
              Text('🏨 عدد الفنادق: $totalHotels'),
              Text('🧹 طلبات التنظيف: $totalCleaning'),
              Text('👤 الضيوف: $totalGuests'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchStats,
                child: const Text('🔄 تحديث الإحصائيات'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GuestFeedbackReportScreen()),
                  );
                },
                child: const Text('⭐ تقارير تقييمات الضيوف'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SubscriptionsScreen()),
                  );
                },
                child: const Text('🕓 إدارة الاشتراكات'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentLinksScreen()),
                  );
                },
                child: const Text('💳 روابط الدفع للفنادق'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SuperAdminSettingsScreen()),
                  );
                },
                child: const Text('⚙️ إعدادات النظام'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HotelsListScreen()),
                  );
                },
                child: const Text('📋 قائمة الفنادق'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
