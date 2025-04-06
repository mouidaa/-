// ✅ شاشة تسجيل الدخول مع دعم الأدوار من Firebase

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/constants/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = userCredential.user!.uid;
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userRole = snapshot.data()!['role'] ?? '';

      if (userRole == UserRoles.admin) {
        Navigator.pushReplacementNamed(context, RouteNames.adminDashboard);
      } else if (userRole == UserRoles.reception) {
        Navigator.pushReplacementNamed(context, RouteNames.home);
      } else if (userRole == UserRoles.cleaner) {
        Navigator.pushReplacementNamed(context, RouteNames.cleaningHome);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ لا تملك صلاحية للوصول')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تسجيل الدخول: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: login,
              child: const Text('تسجيل الدخول'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.register);
              },
              child: const Text('إنشاء حساب جديد'),
            ),
          ],
        ),
      ),
    );
  }
}
