import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hotelsRef = FirebaseFirestore.instance.collection('hotels');

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الاشتراكات')),
      body: StreamBuilder<QuerySnapshot>(
        stream: hotelsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('لا توجد اشتراكات حالياً'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final name = data['name'] ?? 'اسم غير معروف';
              final city = data['city'] ?? 'غير محددة';
              final plan = data['plan'] ?? 'غير محدد';

              final startTimestamp = data['subscriptionStart'] as Timestamp?;
              final endTimestamp = data['subscriptionEnd'] as Timestamp?;
              final startDate = startTimestamp?.toDate();
              final endDate = endTimestamp?.toDate();

              final now = DateTime.now();
              final isActive = endDate != null && endDate.isAfter(now);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('📍 $city'),
                      Text('💼 الباقة: $plan'),
                      if (startDate != null)
                        Text('📅 بداية الاشتراك: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                      if (endDate != null)
                        Text('📆 نهاية الاشتراك: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
                      Text(isActive ? '✅ فعّال' : '❌ منتهي'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final newDate = now.add(const Duration(days: 30));
                          await doc.reference.update({
                            'subscriptionEnd': Timestamp.fromDate(newDate),
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ تم تجديد الاشتراك حتى ${DateFormat('yyyy-MM-dd').format(newDate)}'),
                            ),
                          );
                        },
                        child: const Text('تجديد'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                            ),
                            builder: (context) {
                              String selectedPlan = plan;
                              DateTime? newStartDate = startDate ?? now;
                              DateTime? newEndDate = endDate ?? now.add(const Duration(days: 30));

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                ),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'تعديل اشتراك $name',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        DropdownButtonFormField<String>(
                                          value: selectedPlan,
                                          items: ['أساسي', 'محترف', 'مميز'].map((p) {
                                            return DropdownMenuItem(value: p, child: Text(p));
                                          }).toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                selectedPlan = value;
                                              });
                                            }
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'نوع الاشتراك',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ListTile(
                                          title: const Text('📅 تاريخ البداية'),
                                          subtitle: Text(DateFormat('yyyy-MM-dd').format(newStartDate!)),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: newStartDate!,
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                newStartDate = picked;
                                              });
                                            }
                                          },
                                        ),
                                        ListTile(
                                          title: const Text('📆 تاريخ النهاية'),
                                          subtitle: Text(DateFormat('yyyy-MM-dd').format(newEndDate!)),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: newEndDate!,
                                              firstDate: newStartDate ?? now,
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                newEndDate = picked;
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await doc.reference.update({
                                              'plan': selectedPlan,
                                              'subscriptionStart': Timestamp.fromDate(newStartDate!),
                                              'subscriptionEnd': Timestamp.fromDate(newEndDate!),
                                            });
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('✅ تم تحديث الاشتراك بنجاح'),
                                              ),
                                            );
                                          },
                                          child: const Text('حفظ التعديلات'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                        child: const Text('تعديل'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.link),
                        label: const Text("رابط الدفع"),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                            ),
                            builder: (context) {
                              final _amountController = TextEditingController();
                              final _daysController = TextEditingController();

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                  left: 20,
                                  right: 20,
                                  top: 20,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('إنشاء رابط دفع لـ $name',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: _amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'المبلغ (ر.س)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _daysController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'مدة الاشتراك (أيام)',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final amount = _amountController.text;
                                        final days = _daysController.text;

                                        if (amount.isEmpty || days.isEmpty) return;

                                        final paymentUrl =
                                            'https://pay.example.com/hotel/${doc.id}?amount=$amount';

                                        await doc.reference.update({
                                          'paymentLink': paymentUrl,
                                          'paymentAmount': amount,
                                          'paymentDays': days,
                                          'paymentCreated': Timestamp.now(),
                                        });

                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('✅ تم إنشاء رابط الدفع: $paymentUrl')),
                                        );
                                      },
                                      child: const Text('إنشاء الرابط'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
