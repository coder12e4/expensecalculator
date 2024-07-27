import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/homeproviders.dart';
import '../../core/UserPersistanse/loginData.dart';
import 'addbillspage.dart';
import 'addexpense.dart';
import 'billListing.dart';
import 'expenseListing.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    final List<Widget> widgetOptions = <Widget>[
      BillListScreen(),
      ExpenseListScreen(),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
            child: Text('Add Expense'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBillScreen()),
              );
            },
            child: Text('Add Bill'),
          ),
        ],
      ),
    ];
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Billing',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
      ),
      body: Center(
        child: widgetOptions.elementAt(selectedIndex),
      ),
    );
  }
}
