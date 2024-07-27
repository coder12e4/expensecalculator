import 'package:cloud_firestore/cloud_firestore.dart';

class BillModel {
  final String id;
  final String userId;
  final double amount;
  final String description;
  final DateTime dueDate;
  final bool notificationSent;

  BillModel(
      {required this.id,
      required this.userId,
      required this.amount,
      required this.description,
      required this.dueDate,
      required this.notificationSent});

  factory BillModel.fromMap(Map<String, dynamic> data, String id) {
    return BillModel(
      id: id,
      userId: data['user_id'] ?? '',
      amount: data['amount']?.toDouble() ?? 0.0,
      description: data['description'] ?? '',
      dueDate: (data['due_date'] as Timestamp).toDate(),
      notificationSent: data['notification_sent'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'amount': amount,
      'description': description,
      'due_date': dueDate,
      'notification_sent': notificationSent,
    };
  }

  BillModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? description,
    DateTime? dueDate,
    bool? notificationSent,
  }) {
    return BillModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      notificationSent: notificationSent ?? this.notificationSent,
    );
  }
}
