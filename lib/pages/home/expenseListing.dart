import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/billprovider.dart';
import '../../Providers/expenseProvider.dart';
import '../../core/UserPersistanse/loginData.dart';

class ExpenseListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userid = ref.watch(authProvider);
    final expenseState = ref.watch(expenseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: FutureBuilder(
        future: ref
            .read(expenseProvider.notifier)
            .fetchExpensesForUser(userid.username!),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: expenseState.length,
              itemBuilder: (context, index) {
                final expense = expenseState[index];
                return ListTile(
                  title: Text(expense.description),
                  subtitle:
                      Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                  trailing: Text(
                      'Date: ${expense.date.toLocal().toString().split(' ')[0]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
