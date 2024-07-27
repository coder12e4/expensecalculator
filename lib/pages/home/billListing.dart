import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/billprovider.dart';
import '../../core/UserPersistanse/loginData.dart';

class BillListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userid = ref.watch(authProvider);
    final billState = ref.watch(billProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bills'),
      ),
      body: FutureBuilder(
        future: ref
            .read(billProvider.notifier)
            .fetchBillsForUser("CcHHkz0m14UTHRtlrDuOxzJBCWp1"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: billState.length,
              itemBuilder: (context, index) {
                final bill = billState[index];
                return ListTile(
                  title: Text(bill.description),
                  subtitle: Text('Amount: \$${bill.amount.toStringAsFixed(2)}'),
                  trailing: Text(
                      'Due Date: ${bill.dueDate.toLocal().toString().split(' ')[0]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
