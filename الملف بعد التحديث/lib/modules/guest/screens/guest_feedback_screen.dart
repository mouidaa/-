// lib/modules/guest_app/screens/guest_feedback_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestFeedbackScreen extends StatefulWidget {
  const GuestFeedbackScreen({super.key});

  @override
  State<GuestFeedbackScreen> createState() => _GuestFeedbackScreenState();
}

class _GuestFeedbackScreenState extends State<GuestFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('guest_feedback').add({
        'name': _nameController.text.trim(),
        'feedback': _feedbackController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إرسال الملاحظة بنجاح')),
      );

      _nameController.clear();
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ملاحظات الضيوف')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم'),
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(labelText: 'ملاحظتك'),
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? 'يرجى كتابة الملاحظة' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitFeedback,
                child: const Text('إرسال'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
