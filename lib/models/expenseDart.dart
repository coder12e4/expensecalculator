import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String description;
  final DateTime date;

  ExpenseModel(
      {required this.id,
      required this.userId,
      required this.categoryId,
      required this.amount,
      required this.description,
      required this.date});

  factory ExpenseModel.fromMap(Map<String, dynamic> data, String id) {
    return ExpenseModel(
      id: id,
      userId: data['user_id'] ?? '',
      categoryId: data['category_id'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'description': description,
      'date': date,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    String? categoryId,
    double? amount,
    String? description,
    DateTime? date,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
