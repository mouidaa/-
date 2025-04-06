import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/user_roles.dart';

class RoleProtectedScreen extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;

  const RoleProtectedScreen({
    super.key,
    required this.child,
    required this.allowedRoles,
  });

  Future<String?> _getUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return snapshot.data()?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = snapshot.data;

        if (role == null || !allowedRoles.contains(role)) {
          return const Scaffold(
            body: Center(child: Text('🚫 ليس لديك صلاحية الوصول لهذه الصفحة')),
          );
        }

        return child;
      },
    );
  }
}
