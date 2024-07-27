import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';
import '../models/billmodel.dart';

final billProvider = StateNotifierProvider<BillNotifier, List<BillModel>>(
    (ref) => BillNotifier());

class BillNotifier extends StateNotifier<List<BillModel>> {
  BillNotifier() : super([]);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBill(double amount, String description, DateTime dueDate,
      String userid) async {
    final bill = BillModel(
      id: '',
      userId: userid, // replace with actual user id
      amount: amount,
      description: description,
      dueDate: dueDate,
      notificationSent: false,
    );
    final docRef = await _firestore.collection('bills').add(bill.toMap());
    _scheduleNotification(docRef.id, bill);
    state = [...state, bill.copyWith(id: docRef.id)];
  }

  Future<void> fetchBillsForUser(String userId) async {
    final querySnapshot = await _firestore
        .collection('bills')
        .where('user_id', isEqualTo: userId)
        .get();

    final bills = querySnapshot.docs
        .map((doc) => BillModel.fromMap(doc.data(), doc.id))
        .toList();

    state = bills;
  }

  void _scheduleNotification(String billId, BillModel bill) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    /*   await flutterLocalNotificationsPlugin.schedule(
        0,
        'Bill Due Reminder',
        'Your bill for ${bill.description} is due on ${bill.dueDate}',
        bill.dueDate,
        platformChannelSpecifics);*/
  }
}
