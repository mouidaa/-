// lib/modules/models/booking_model.dart

class BookingModel {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String roomNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String paymentMethod;
  final String status;

  BookingModel({
    this.id = '',
    required this.customerName,
    required this.phoneNumber,
    required this.roomNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'roomNumber': roomNumber,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String docId) {
    return BookingModel(
      id: docId,
      customerName: map['customerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      roomNumber: map['roomNumber'] ?? '',
      checkInDate: DateTime.tryParse(map['checkInDate'] ?? '') ?? DateTime.now(),
      checkOutDate: DateTime.tryParse(map['checkOutDate'] ?? '') ?? DateTime.now(),
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? 'pending',
    );
  }
}
