import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Providers/billprovider.dart';
import '../../core/UserPersistanse/loginData.dart';

class AddBillScreen extends ConsumerWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userid = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(billProvider.notifier).addBill(
                    double.parse(amountController.text),
                    descriptionController.text,
                    DateTime.parse(dueDateController.text),
                    userid.username!);
                Navigator.pop(context);
              },
              child: Text('Add Bill'),
            ),
          ],
        ),
      ),
    );
  }
}
