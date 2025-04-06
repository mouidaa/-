// ✅ شاشة تسجيل حساب جديدة مع اختيار الدور

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/user_roles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = UserRoles.reception;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register() async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': emailController.text.trim(),
        'role': selectedRole,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم إنشاء الحساب بنجاح')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ فشل في إنشاء الحساب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: 'اختر الدور'),
              items: const [
                DropdownMenuItem(value: UserRoles.admin, child: Text('مالك / Admin')),
                DropdownMenuItem(value: UserRoles.reception, child: Text('موظف استقبال')),
                DropdownMenuItem(value: UserRoles.cleaner, child: Text('موظف نظافة')),
                DropdownMenuItem(value: UserRoles.support, child: Text('دعم فني')),
              ],
              onChanged: (value) => setState(() => selectedRole = value!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: register,
              child: const Text('تسجيل الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}
