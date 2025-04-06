import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String status;

  const RoomCard({super.key, required this.roomName, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(roomName),
        subtitle: Text('الحالة: $status'),
        trailing: status == 'متاحة'
            ? Icon(Icons.check_circle, color: Colors.green)
            : Icon(Icons.remove_circle, color: Colors.red),
      ),
    );
  }
}
