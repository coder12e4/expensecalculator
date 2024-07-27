import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expenseDart.dart';

final expenseProvider =
    StateNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
        (ref) => ExpenseNotifier());

class ExpenseNotifier extends StateNotifier<List<ExpenseModel>> {
  ExpenseNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(
      double amount, String description, String userId) async {
    print(userId);
    final expense = ExpenseModel(
      id: '',
      userId: userId, // replace with actual user id
      categoryId: 'your-category-id', // replace with actual category id
      amount: amount,
      description: description,
      date: DateTime.now(),
    );
    final docRef = await _firestore.collection('expenses').add(expense.toMap());
    state = [...state, expense.copyWith(id: docRef.id)];
  }

  Future<void> fetchExpensesForUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('expenses')
        .where('user_id', isEqualTo: userId)
        .get();

    final expenses = querySnapshot.docs
        .map((doc) => ExpenseModel.fromMap(doc.data(), doc.id))
        .toList();

    state = expenses;
  }
}
