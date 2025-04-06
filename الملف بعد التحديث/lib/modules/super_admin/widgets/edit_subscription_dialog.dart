import 'package:flutter/material.dart';

class EditSubscriptionDialog extends StatefulWidget {
  final String hotelName;
  final String currentPlan;
  final Function(String newPlan) onSave;

  const EditSubscriptionDialog({
    required this.hotelName,
    required this.currentPlan,
    required this.onSave,
    super.key,
  });

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  late String selectedPlan;

  @override
  void initState() {
    super.initState();
    selectedPlan = widget.currentPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'تعديل اشتراك ${widget.hotelName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedPlan,
            items: ['أساسي', 'محترف', 'مميز'].map((plan) {
              return DropdownMenuItem(value: plan, child: Text(plan));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedPlan = value;
                });
              }
            },
            decoration: InputDecoration(
              labelText: 'نوع الاشتراك',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              widget.onSave(selectedPlan);
              Navigator.of(context).pop();
            },
            child: Text('حفظ التعديلات'),
          ),
        ],
      ),
    );
  }
}
