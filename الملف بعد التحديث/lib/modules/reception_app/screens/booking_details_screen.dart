// lib/modules/reception_app/screens/booking_details_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/booking_model.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  void _printInvoice(BuildContext context) async {
    final pdf = pw.Document();
    final formatter = DateFormat('yyyy-MM-dd');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('فاتورة الحجز', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('العميل: ${booking.customerName}'),
            pw.Text('رقم الغرفة: ${booking.roomNumber}'),
            pw.Text('طريقة الدفع: ${booking.paymentMethod}'),
            pw.Text('الحالة: ${booking.status}'),
            pw.Text('تاريخ الوصول: ${formatter.format(booking.checkInDate)}'),
            pw.Text('تاريخ المغادرة: ${formatter.format(booking.checkOutDate)}'),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('العميل: ${booking.customerName}', style: const TextStyle(fontSize: 18)),
            Text('رقم الغرفة: ${booking.roomNumber}', style: const TextStyle(fontSize: 18)),
            Text('طريقة الدفع: ${booking.paymentMethod}', style: const TextStyle(fontSize: 18)),
            Text('الحالة: ${booking.status}', style: const TextStyle(fontSize: 18)),
            Text('تاريخ الوصول: ${formatter.format(booking.checkInDate)}', style: const TextStyle(fontSize: 18)),
            Text('تاريخ المغادرة: ${formatter.format(booking.checkOutDate)}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.print),
                label: const Text('طباعة الفاتورة'),
                onPressed: () => _printInvoice(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
