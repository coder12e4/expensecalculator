import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/expenseProvider.dart';
import '../../core/UserPersistanse/loginData.dart';

class AddExpenseScreen extends ConsumerWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userid = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(expenseProvider.notifier).addExpense(
                    double.parse(amountController.text),
                    descriptionController.text,
                    userid.username!);
                Navigator.pop(context);
              },
              child: Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
