import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelDetailsScreen extends StatefulWidget {
  final String hotelId;

  const HotelDetailsScreen({super.key, required this.hotelId});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'reception';

  Future<void> addUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    final auth = FirebaseFirestore.instance;
    final usersCollection = FirebaseFirestore.instance.collection('users');

    try {
      // ❗️هنا يفترض إنشاء مستخدم جديد في Firebase Auth أيضاً - لكننا نضيفه فقط في Firestore
      await usersCollection.add({
        'email': email,
        'role': selectedRole,
        'hotelId': widget.hotelId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم إضافة المستخدم')),
      );
      emailController.clear();
      passwordController.clear();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersCollection = FirebaseFirestore.instance
        .collection('users')
        .where('hotelId', isEqualTo: widget.hotelId);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الفندق')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'كلمة المرور'),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: const InputDecoration(labelText: 'الصلاحية'),
                  items: const [
                    DropdownMenuItem(value: 'reception', child: Text('موظف استقبال')),
                    DropdownMenuItem(value: 'cleaner', child: Text('عامل نظافة')),
                    DropdownMenuItem(value: 'support', child: Text('دعم فني')),
                  ],
                  onChanged: (value) => setState(() => selectedRole = value!),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: addUser,
                  child: const Text('➕ إضافة المستخدم'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('لا يوجد مستخدمون لهذا الفندق'));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final email = user['email'] ?? 'بدون بريد';
                    final role = user['role'] ?? 'غير محدد';

                    return ListTile(
                      title: Text(email),
                      subtitle: Text('الدور: $role'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await users[index].reference.delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('🗑️ تم حذف المستخدم')),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
