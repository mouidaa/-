import 'package:flutter/material.dart';

class CleaningRequestsScreen extends StatelessWidget {
  const CleaningRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cleaning Requests"),
      ),
      body: const Center(
        child: Text(
          'List of rooms needing cleaning will appear here',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
