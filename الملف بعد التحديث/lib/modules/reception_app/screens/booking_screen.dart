// lib/modules/reception_app/screens/booking_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/route_names.dart';
import '../../../modules/models/booking_model.dart';
import '../../../services/firebase_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final roomController = TextEditingController();
  DateTime? checkInDate;
  DateTime? checkOutDate;
  String paymentMethod = 'كاش';
  String status = 'pending';

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() &&
        checkInDate != null &&
        checkOutDate != null) {
      final newBooking = BookingModel(
        customerName: nameController.text,
        phoneNumber: phoneController.text,
        roomNumber: roomController.text,
        checkInDate: checkInDate!,
        checkOutDate: checkOutDate!,
        paymentMethod: paymentMethod,
        status: status,
      );

      await FirebaseService.addBooking(newBooking);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ الحجز بنجاح')),
      );

      Navigator.pushNamed(context, RouteNames.bookingsList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حجز جديد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'اسم العميل'),
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال اسم العميل' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'رقم الجوال'),
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال رقم الجوال' : null,
              ),
              TextFormField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'رقم الغرفة'),
                validator: (value) =>
                value!.isEmpty ? 'يرجى إدخال رقم الغرفة' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      checkInDate == null
                          ? 'تاريخ الوصول'
                          : 'الوصول: ${DateFormat('yyyy-MM-dd').format(checkInDate!)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () => _selectDate(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      checkOutDate == null
                          ? 'تاريخ المغادرة'
                          : 'المغادرة: ${DateFormat('yyyy-MM-dd').format(checkOutDate!)}',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    onPressed: () => _selectDate(context, false),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                items: const [
                  DropdownMenuItem(value: 'كاش', child: Text('كاش')),
                  DropdownMenuItem(value: 'شبكة', child: Text('شبكة')),
                ],
                onChanged: (value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('تأكيد الحجز'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
